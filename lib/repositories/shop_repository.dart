import 'dart:convert';

import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/shop/shop_model.dart';
import '../utils/api_endpoints.dart';

class ShopRepository extends BaseRepository<Shop> {
  ShopRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(baseEndpoint: ApiEndpoints.shops);

  static const _shopsCacheKey = 'shops_all';

  @override
  Shop fromJson(Map<String, dynamic> json) => Shop.fromJson(json);

  @override
  Future<Result<List<Shop>>> getAll({bool useCache = true}) async {
    try {
      if (useCache) {
        final cached = _readCachedShops();
        if (cached != null) {
          _refreshInBackground();
          return Result.success(cached);
        }
      }

      final response = await apiService.get<dynamic>(baseEndpoint);
      if (response.success && response.data != null) {
        final shops = _parseShopsPayload(response.data);
        await _saveShopsCache(shops);
        return Result.success(shops);
      }

      if (useCache) {
        final cached = _readCachedShops();
        if (cached != null) return Result.success(cached);
      }

      return Result.failure(
        ApiError(message: response.message ?? 'Failed to fetch shops'),
      );
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      final response = await apiService.get<dynamic>(baseEndpoint);
      if (!response.success || response.data == null) return;
      await _saveShopsCache(_parseShopsPayload(response.data));
    } catch (_) {}
  }

  List<Shop>? _readCachedShops() {
    final raw = databaseService.get<String>(_shopsCacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      final shops = decoded
          .whereType<Map>()
          .map((e) => Shop.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return shops.isEmpty ? null : shops;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveShopsCache(List<Shop> shops) async {
    await databaseService.save(
      _shopsCacheKey,
      jsonEncode(shops.map((e) => e.toJson()).toList()),
    );
  }

  List<Shop> _parseShopsPayload(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Shop.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final list = map['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => Shop.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return const <Shop>[];
  }
}
