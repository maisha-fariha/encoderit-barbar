import 'dart:convert';

import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/appointment/appointment_model.dart';

class AppointmentPageResult {
  const AppointmentPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<AppointmentModel> items;
  final int currentPage;
  final int lastPage;
  final int total;
}

class AppointmentRepository extends BaseRepository<AppointmentModel> {
  AppointmentRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(baseEndpoint: '/profile/appointments');

  static const _cacheKey = 'appointments_all';

  @override
  AppointmentModel fromJson(Map<String, dynamic> json) =>
      AppointmentModel.fromJson(json);

  Future<Result<void>> deleteAppointment(String appointmentId) async {
    try {
      final response = await apiService.delete<dynamic>('/appointments/$appointmentId');
      if (response.success) {
        return Result.success(null);
      }
      return Result.failure(
        ApiError(message: response.message ?? 'Failed to delete appointment'),
      );
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<List<AppointmentModel>>> getAll({bool useCache = true}) async {
    final pageResult = await getPage(1, useCache: useCache);
    return pageResult.when(
      success: (data) => Result.success(data.items),
      failure: (error) => Result.failure(error),
    );
  }

  Future<Result<AppointmentPageResult>> getPage(
    int page, {
    bool useCache = true,
  }) async {
    try {
      if (useCache && page == 1) {
        final cached = _readCache();
        if (cached != null) {
          _refreshInBackground();
          return Result.success(
            AppointmentPageResult(
              items: cached,
              currentPage: 1,
              lastPage: 1,
              total: cached.length,
            ),
          );
        }
      }

      final response = await apiService.get<dynamic>(
        baseEndpoint,
        queryParameters: {'page': page},
      );
      if (response.success && response.data != null) {
        final parsed = _parsePage(response.data);
        if (page == 1) {
          await _saveCache(parsed.items);
        }
        return Result.success(parsed);
      }

      if (useCache && page == 1) {
        final cached = _readCache();
        if (cached != null) {
          return Result.success(
            AppointmentPageResult(
              items: cached,
              currentPage: 1,
              lastPage: 1,
              total: cached.length,
            ),
          );
        }
      }

      return Result.failure(
        ApiError(message: response.message ?? 'Failed to fetch appointments'),
      );
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      final response = await apiService.get<dynamic>(
        baseEndpoint,
        queryParameters: {'page': 1},
      );
      if (response.success && response.data != null) {
        await _saveCache(_parsePage(response.data).items);
      }
    } catch (_) {}
  }

  List<AppointmentModel>? _readCache() {
    final raw = databaseService.get<String>(_cacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      final list = decoded
          .whereType<Map>()
          .map((e) => AppointmentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list.isEmpty ? null : list;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCache(List<AppointmentModel> list) async {
    await databaseService.save(
      _cacheKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  List<AppointmentModel> _parseList(dynamic raw) {
    final extracted = _extractAppointmentRows(raw);
    if (extracted == null) return const <AppointmentModel>[];
    return extracted
        .whereType<Map>()
        .map((e) => AppointmentModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  AppointmentPageResult _parsePage(dynamic raw) {
    final list = _parseList(raw);
    int currentPage = 1;
    int lastPage = 1;
    int total = list.length;

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final metaRaw = map['meta'];
      if (metaRaw is Map) {
        final meta = Map<String, dynamic>.from(metaRaw);
        final current = meta['current_page'];
        final last = meta['last_page'];
        final totalRaw = meta['total'];
        if (current is int) currentPage = current;
        if (last is int) lastPage = last;
        if (totalRaw is int) total = totalRaw;
      }
    }

    return AppointmentPageResult(
      items: list,
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }

  List<dynamic>? _extractAppointmentRows(dynamic raw) {
    if (raw is List) return raw;
    if (raw is! Map) return null;

    final map = Map<String, dynamic>.from(raw);

    // Common API envelopes:
    // 1) { data: [ ... ] }
    // 2) { data: { appointments: [ ... ] } }
    // 3) { appointments: [ ... ] }
    // 4) { result: [ ... ] } or any first list-like field
    final directData = map['data'];
    if (directData is List) return directData;
    if (directData is Map) {
      final dataMap = Map<String, dynamic>.from(directData);
      final nestedAppointments = dataMap['appointments'];
      if (nestedAppointments is List) return nestedAppointments;
      final nestedData = dataMap['data'];
      if (nestedData is List) return nestedData;
      for (final value in dataMap.values) {
        if (value is List) return value;
      }
    }

    final appointments = map['appointments'];
    if (appointments is List) return appointments;

    final result = map['result'];
    if (result is List) return result;

    for (final value in map.values) {
      if (value is List) return value;
    }

    return null;
  }
}
