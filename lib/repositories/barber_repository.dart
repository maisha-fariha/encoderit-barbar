import 'dart:convert';

import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/barber/barber_model.dart';
import '../models/schedule/vacation_period_model.dart';
import '../utils/api_endpoints.dart';

class BarberRepository extends BaseRepository<BarberModel> {
  BarberRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(baseEndpoint: ApiEndpoints.barbers);

  @override
  BarberModel fromJson(Map<String, dynamic> json) => BarberModel.fromJson(json);

  Future<Result<List<BarberModel>>> getByShopAndService({
    required String shopId,
    required String serviceId,
  }) async {
    final cacheKey = 'barbers_${shopId}_$serviceId';
    try {
      final cached = _readCache(cacheKey);
      if (cached != null) {
        _refreshInBackground(
          shopId: shopId,
          serviceId: serviceId,
          cacheKey: cacheKey,
        );
        return Result.success(cached);
      }

      final response = await apiService.get<dynamic>(
        baseEndpoint,
        queryParameters: {'shop_id': shopId, 'service_id': serviceId},
      );
      if (response.success && response.data != null) {
        final barbers = _parseList(response.data);
        await _saveCache(cacheKey, barbers);
        return Result.success(barbers);
      }

      final fallback = _readCache(cacheKey);
      if (fallback != null) return Result.success(fallback);

      return Result.failure(
        ApiError(message: response.message ?? 'Failed to fetch barbers'),
      );
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  Future<void> _refreshInBackground({
    required String shopId,
    required String serviceId,
    required String cacheKey,
  }) async {
    try {
      final response = await apiService.get<dynamic>(
        baseEndpoint,
        queryParameters: {'shop_id': shopId, 'service_id': serviceId},
      );
      if (response.success && response.data != null) {
        await _saveCache(cacheKey, _parseList(response.data));
      }
    } catch (_) {}
  }

  List<BarberModel>? _readCache(String key) {
    final raw = databaseService.get<String>(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      final barbers = decoded
          .whereType<Map>()
          .map((e) => BarberModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return barbers.isEmpty ? null : barbers;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCache(String key, List<BarberModel> values) async {
    await databaseService.save(
      key,
      jsonEncode(values.map((e) => e.toJson()).toList()),
    );
  }

  Future<Result<BarberVacationsResult>> getVacations(String barberId) async {
    try {
      final response = await apiService.get<dynamic>(
        ApiEndpoints.barberVacations(barberId),
      );
      if (response.success && response.data != null) {
        return Result.success(_parseVacationsPayload(response.data));
      }
      return Result.failure(
        ApiError(message: response.message ?? 'Failed to fetch barber vacations'),
      );
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  BarberVacationsResult _parseVacationsPayload(dynamic raw) {
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final data = map['data'];
      if (data is Map) {
        return BarberVacationsResult.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
      if (map.containsKey('barber_vacations') ||
          map.containsKey('shop_vacations')) {
        return BarberVacationsResult.fromJson(map);
      }
    }
    return BarberVacationsResult.empty;
  }

  List<BarberModel> _parseList(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => BarberModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final list = map['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => BarberModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return const <BarberModel>[];
  }
}
