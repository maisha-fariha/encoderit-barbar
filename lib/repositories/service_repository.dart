import 'dart:convert';

import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/service/service_model.dart';
import '../utils/api_endpoints.dart';

class ServiceRepository extends BaseRepository<ServiceModel> {
  ServiceRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(baseEndpoint: ApiEndpoints.services);

  @override
  ServiceModel fromJson(Map<String, dynamic> json) =>
      ServiceModel.fromJson(json);

  Future<Result<List<ServiceModel>>> getByShopId(String shopId) async {
    final cacheKey = 'services_shop_$shopId';
    try {
      final cached = _readCache(cacheKey);
      if (cached != null) {
        _refreshInBackground(shopId, cacheKey);
        return Result.success(cached);
      }

      final response = await apiService.get<dynamic>(
        baseEndpoint,
        queryParameters: {'shop_id': shopId},
      );
      if (response.success && response.data != null) {
        final services = _parseList(response.data);
        await _saveCache(cacheKey, services);
        return Result.success(services);
      }

      final fallback = _readCache(cacheKey);
      if (fallback != null) return Result.success(fallback);

      return Result.failure(
        ApiError(message: response.message ?? 'Failed to fetch services'),
      );
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  Future<void> _refreshInBackground(String shopId, String cacheKey) async {
    try {
      final response = await apiService.get<dynamic>(
        baseEndpoint,
        queryParameters: {'shop_id': shopId},
      );
      if (response.success && response.data != null) {
        await _saveCache(cacheKey, _parseList(response.data));
      }
    } catch (_) {}
  }

  List<ServiceModel>? _readCache(String key) {
    final raw = databaseService.get<String>(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      final services = decoded
          .whereType<Map>()
          .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return services.isEmpty ? null : services;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCache(String key, List<ServiceModel> values) async {
    await databaseService.save(
      key,
      jsonEncode(values.map((e) => e.toJson()).toList()),
    );
  }

  List<ServiceModel> _parseList(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final list = map['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return const <ServiceModel>[];
  }
}
