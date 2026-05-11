import 'dart:convert';

import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/appointment/availability_slot_model.dart';
import '../utils/api_endpoints.dart';

class AvailabilityRepository {
  AvailabilityRepository({
    required this.apiService,
    required this.databaseService,
  });

  final ApiService apiService;
  final DatabaseService databaseService;

  Future<Result<AvailabilitySlotsResult>> getSlots({
    required int shopId,
    required int serviceId,
    required int barberId,
    required String date, // YYYY-MM-DD
  }) async {
    final cacheKey = _cacheKey(
      shopId: shopId,
      serviceId: serviceId,
      barberId: barberId,
      date: date,
    );

    try {
      final response = await apiService.get<dynamic>(
        ApiEndpoints.availabilitySlots,
        queryParameters: <String, dynamic>{
          'shop_id': shopId,
          'service_id': serviceId,
          'barber_id': barberId,
          'date': date,
        },
      );

      if (response.success && response.data != null) {
        final parsed = _parsePayload(response.data);
        if (parsed != null) {
          await databaseService.save(cacheKey, jsonEncode(parsed.toJson()));
          return Result.success(parsed);
        }
      }

      final cached = _readCache(cacheKey);
      if (cached != null) {
        return Result.success(cached);
      }

      return Result.failure(
        ApiError(message: response.message ?? 'Failed to fetch availability'),
      );
    } catch (e, stackTrace) {
      final cached = _readCache(cacheKey);
      if (cached != null) {
        return Result.success(cached);
      }
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  AvailabilitySlotsResult? _parsePayload(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final source = map['slots'] != null
        ? map
        : (map['data'] is Map
              ? Map<String, dynamic>.from(map['data'] as Map)
              : map);
    try {
      final parsed = AvailabilitySlotsResult.fromJson(source);
      return parsed.slots.isEmpty ? parsed : parsed;
    } catch (_) {
      return null;
    }
  }

  AvailabilitySlotsResult? _readCache(String key) {
    final raw = databaseService.get<String>(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return AvailabilitySlotsResult.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  String _cacheKey({
    required int shopId,
    required int serviceId,
    required int barberId,
    required String date,
  }) {
    return 'availability_slots_${shopId}_${serviceId}_${barberId}_$date';
  }
}
