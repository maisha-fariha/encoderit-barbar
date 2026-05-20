import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:get/get.dart';

import '../controllers/appointment_ui_refresh_controller.dart';
import '../models/appointment/appointment_model.dart';
import '../models/appointment/recurring_preview_model.dart';
import '../utils/api_endpoints.dart';

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

/// Result of a single booking attempt.
///
/// On success: [appointment] is non-null and [message] holds the API message.
/// On business failure (e.g. slot already booked): [success] is false,
/// [message] holds the user-facing reason and [errors] holds the raw API
/// errors map.
class BookAppointmentOutcome {
  const BookAppointmentOutcome({
    required this.success,
    required this.message,
    this.appointment,
    this.errors,
    this.statusCode,
    this.isNetworkError = false,
  });

  final bool success;
  final String message;
  final AppointmentModel? appointment;
  final Map<String, dynamic>? errors;
  final int? statusCode;
  final bool isNetworkError;
}

/// Result of a recurring booking attempt.
///
/// The API can return `success: true` even when some/all slots are skipped
/// (e.g. already booked, shop on vacation). [result] carries the parsed
/// `data` envelope so the UI can decide how to surface partial outcomes.
class BookRecurringOutcome {
  const BookRecurringOutcome({
    required this.success,
    required this.message,
    this.result,
    this.errors,
    this.statusCode,
    this.isNetworkError = false,
  });

  final bool success;
  final String message;
  final RecurringAppointmentResult? result;
  final Map<String, dynamic>? errors;
  final int? statusCode;
  final bool isNetworkError;

  /// True when the API succeeded but no actual appointments were created.
  bool get allSlotsSkipped =>
      success &&
      (result?.booked.isEmpty ?? true) &&
      (result?.skipped.isNotEmpty ?? false);

  /// True when the API succeeded with at least one slot skipped.
  bool get hasSkippedSlots =>
      success && (result?.skipped.isNotEmpty ?? false);
}

class RecurringPreviewOutcome {
  const RecurringPreviewOutcome({
    required this.success,
    required this.message,
    this.result,
    this.errors,
    this.statusCode,
    this.isNetworkError = false,
  });

  final bool success;
  final String message;
  final RecurringPreviewResult? result;
  final Map<String, dynamic>? errors;
  final int? statusCode;
  final bool isNetworkError;
}

class AppointmentRepository extends BaseRepository<AppointmentModel> {
  AppointmentRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(baseEndpoint: '/profile/appointments');

  static const _cacheKey = 'appointments_all';

  /// Clears cached appointment list so the next fetch hits the network.
  Future<void> invalidateAppointmentsCache() async {
    await databaseService.delete(_cacheKey);
  }

  @override
  AppointmentModel fromJson(Map<String, dynamic> json) =>
      AppointmentModel.fromJson(json);

  /// POST `/appointments` — books a single (non-recurring) appointment.
  ///
  /// Always returns a structured [BookAppointmentOutcome]; never throws.
  Future<BookAppointmentOutcome> bookAppointment(
    AppointmentBookingRequest request,
  ) async {
    final body = request.toJson();
    if (kDebugMode) {
      debugPrint(
        '[AppointmentRepository] POST ${ApiEndpoints.appointments} body=$body',
      );
    }

    try {
      final response = await apiService.post<dynamic>(
        ApiEndpoints.appointments,
        data: body,
      );

      if (kDebugMode) {
        debugPrint(
          '[AppointmentRepository] response success=${response.success} '
          'status=${response.statusCode} message=${response.message}',
        );
      }

      if (response.success) {
        final appointment = _parseSingleAppointment(response.data);
        return BookAppointmentOutcome(
          success: true,
          message: (response.message ?? '').trim(),
          appointment: appointment,
          statusCode: response.statusCode,
        );
      }

      return BookAppointmentOutcome(
        success: false,
        message: (response.message ?? '').trim(),
        errors: response.errors,
        statusCode: response.statusCode,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AppointmentRepository] exception: $e\n$st');
      }
      return BookAppointmentOutcome(
        success: false,
        message: e.toString(),
        isNetworkError: true,
      );
    }
  }

  /// POST `/appointments/recurring` — books a series of appointments.
  ///
  /// Always returns a structured [BookRecurringOutcome]; never throws.
  /// The caller is expected to inspect [BookRecurringOutcome.hasSkippedSlots]
  /// and surface partial outcomes appropriately.
  Future<BookRecurringOutcome> bookRecurringAppointment(
    RecurringAppointmentRequest request,
  ) async {
    final body = request.toJson();
    return bookRecurringAppointmentBody(body);
  }

  /// POST `/appointments/recurring` with a raw request body.
  Future<BookRecurringOutcome> bookRecurringAppointmentBody(
    Map<String, dynamic> body,
  ) async {
    if (kDebugMode) {
      debugPrint(
        '[AppointmentRepository] POST ${ApiEndpoints.appointmentsRecurring} '
        'body=$body',
      );
    }

    try {
      final response = await apiService.post<dynamic>(
        ApiEndpoints.appointmentsRecurring,
        data: body,
      );

      if (kDebugMode) {
        debugPrint(
          '[AppointmentRepository] recurring response success=${response.success} '
          'status=${response.statusCode} message=${response.message}',
        );
      }

      if (response.success) {
        final result = _parseRecurringResult(response.data);
        return BookRecurringOutcome(
          success: true,
          message: (response.message ?? '').trim(),
          result: result,
          statusCode: response.statusCode,
        );
      }

      return BookRecurringOutcome(
        success: false,
        message: (response.message ?? '').trim(),
        errors: response.errors,
        statusCode: response.statusCode,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AppointmentRepository] recurring exception: $e\n$st');
      }
      return BookRecurringOutcome(
        success: false,
        message: e.toString(),
        isNetworkError: true,
      );
    }
  }

  /// POST `/appointments/recurring/preview` — previews recurring dates/statuses.
  Future<RecurringPreviewOutcome> previewRecurring({
    required int shopId,
    required int barberId,
    required int serviceId,
    required String date,
    required String time,
    required int quantity,
    required int interval,
    String type = 'weekly',
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'shop_id': shopId,
      'barber_id': barberId,
      'service_id': serviceId,
      'date': date,
      'time': time,
      'notes': notes,
      'repeat': <String, dynamic>{
        'type': type,
        'value': quantity,
        'interval': interval,
      },
    };
    if (kDebugMode) {
      debugPrint(
        '[AppointmentRepository] POST ${ApiEndpoints.appointmentsRecurringPreview} '
        'body=$body',
      );
    }

    try {
      final response = await apiService.post<dynamic>(
        ApiEndpoints.appointmentsRecurringPreview,
        data: body,
      );

      if (response.success) {
        final raw = response.data;
        Map<String, dynamic>? source;
        if (raw is Map && raw['data'] is Map) {
          source = Map<String, dynamic>.from(raw['data'] as Map);
        } else if (raw is Map) {
          source = Map<String, dynamic>.from(raw);
        }
        RecurringPreviewResult? parsed;
        if (source != null) {
          try {
            parsed = RecurringPreviewResult.fromJson(source);
          } catch (_) {}
        }
        return RecurringPreviewOutcome(
          success: true,
          message: (response.message ?? '').trim(),
          result: parsed,
          statusCode: response.statusCode,
        );
      }

      return RecurringPreviewOutcome(
        success: false,
        message: (response.message ?? '').trim(),
        errors: response.errors,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return RecurringPreviewOutcome(
        success: false,
        message: e.toString(),
        isNetworkError: true,
      );
    }
  }

  RecurringAppointmentResult? _parseRecurringResult(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    // Handle both `{ data: { ... } }` and a direct envelope shape.
    final inner = map['data'];
    final source = inner is Map ? Map<String, dynamic>.from(inner) : map;
    try {
      return RecurringAppointmentResult.fromJson(source);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          '[AppointmentRepository] recurring parse failed: $e\n$st (raw=$source)',
        );
      }
      return null;
    }
  }

  AppointmentModel? _parseSingleAppointment(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    // Handle both `{ data: { ... } }` and direct entity payloads.
    final inner = map['data'];
    if (inner is Map) {
      try {
        return AppointmentModel.fromJson(Map<String, dynamic>.from(inner));
      } catch (_) {
        return null;
      }
    }
    try {
      return AppointmentModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<Result<void>> deleteAppointment(String appointmentId) async {
    try {
      final response = await apiService.delete<dynamic>(
        '${ApiEndpoints.appointments}/$appointmentId',
      );
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

  Future<Result<void>> deleteRecurringGroup(String recurringGroupId) async {
    try {
      final response = await apiService.delete<dynamic>(
        '${ApiEndpoints.appointmentsRecurring}/$recurringGroupId',
      );
      if (response.success) {
        return Result.success(null);
      }
      return Result.failure(
        ApiError(
          message: response.message ?? 'Failed to delete recurring appointments',
        ),
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
    bool forceNetwork = false,
  }) async {
    try {
      if (useCache && !forceNetwork && page == 1) {
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
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  /// Fetches appointments filtered by status from `/profile/appointments`.
  ///
  /// Example: `status=booked` for upcoming items shown on the home page.
  Future<Result<List<AppointmentModel>>> getByStatus(
    String status, {
    int page = 1,
  }) async {
    try {
      final response = await apiService.get<dynamic>(
        baseEndpoint,
        queryParameters: {
          'status': status,
          'page': page,
        },
      );
      if (response.success && response.data != null) {
        final list = _parseList(response.data);
        _sortAppointmentsDescending(list);
        return Result.success(list);
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
        _notifyAppointmentsCacheUpdated();
      }
    } catch (_) {}
  }

  void _notifyAppointmentsCacheUpdated() {
    if (Get.isRegistered<AppointmentUiRefreshController>()) {
      Get.find<AppointmentUiRefreshController>().notifyAppointmentsChanged();
    }
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

  void _sortAppointmentsDescending(List<AppointmentModel> list) {
    list.sort((AppointmentModel a, AppointmentModel b) {
      return b.activitySortTime.compareTo(a.activitySortTime);
    });
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

    _sortAppointmentsDescending(list);

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

    final directData = map['data'];
    if (directData is List) return directData;
    if (directData is Map) {
      final dataMap = Map<String, dynamic>.from(directData);
      final individual = dataMap['individual'];
      final recurringGroups = dataMap['recurring_groups'];
      if (individual is List || recurringGroups is List) {
        final merged = <dynamic>[];
        if (individual is List) {
          merged.addAll(individual);
        }
        if (recurringGroups is List) {
          for (final group in recurringGroups) {
            if (group is! Map) continue;
            final appointments = group['appointments'];
            if (appointments is List) {
              merged.addAll(appointments);
            }
          }
        }
        if (merged.isNotEmpty) return merged;
      }
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
