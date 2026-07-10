import 'dart:convert';

import 'package:gems_core/gems_core.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../models/schedule/shop_holiday_model.dart';
import '../models/shop/shop_model.dart';
import '../utils/api_endpoints.dart';

class ShopRepository extends BaseRepository<Shop> {
  ShopRepository({
    required super.apiService,
    required super.databaseService,
    required super.syncService,
  }) : super(baseEndpoint: ApiEndpoints.shops);

  static const _shopsCacheKey = 'shops_all_v2';

  @override
  Shop fromJson(Map<String, dynamic> json) => Shop.fromJson(json);

  /// Fetches shops from the API first; uses local cache only when offline/failed.
  @override
  Future<Result<List<Shop>>> getAll({bool useCache = true}) async {
    try {
      final response = await apiService.get<dynamic>(baseEndpoint);
      if (response.success && response.data != null) {
        final shops = dedupeShops(_parseShopsPayload(response.data));
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
      if (useCache) {
        final cached = _readCachedShops();
        if (cached != null) return Result.success(cached);
      }
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  Future<void> clearShopsCache() async {
    await databaseService.delete(_shopsCacheKey);
  }

  List<Shop>? _readCachedShops() {
    final raw = databaseService.get<String>(_shopsCacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      final shops = dedupeShops(
        decoded
            .whereType<Map>()
            .map((e) => Shop.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
      return shops.isEmpty ? null : shops;
    } catch (_) {
      return null;
    }
  }

  static List<Shop> dedupeShops(List<Shop> shops) {
    final seen = <String>{};
    final unique = <Shop>[];
    for (final shop in shops) {
      final id = shop.id.trim();
      if (id.isEmpty) {
        unique.add(shop);
        continue;
      }
      if (seen.add(id)) {
        unique.add(shop);
      }
    }
    return unique;
  }

  Future<void> _saveShopsCache(List<Shop> shops) async {
    await databaseService.save(
      _shopsCacheKey,
      jsonEncode(shops.map((e) => e.toJson()).toList()),
    );
  }

  Future<Result<List<ShopHoliday>>> getHolidays(String shopId) async {
    try {
      final response = await apiService.get<dynamic>(
        ApiEndpoints.shopHolidays(shopId),
      );
      if (response.success && response.data != null) {
        return Result.success(_parseHolidaysPayload(response.data));
      }
      return Result.failure(
        ApiError(message: response.message ?? 'Failed to fetch shop holidays'),
      );
    } catch (e, stackTrace) {
      return Result.failure(NetworkError.fromException(e, stackTrace));
    }
  }

  List<ShopHoliday> _parseHolidaysPayload(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => ShopHoliday.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final list = map['data'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => ShopHoliday.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    return const <ShopHoliday>[];
  }

  List<Shop> _parseShopsPayload(dynamic raw) {
    if (raw is List) {
      return dedupeShops(
        raw
            .whereType<Map>()
            .map((e) => Shop.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final list = map['data'];
      if (list is List) {
        return dedupeShops(
          list
              .whereType<Map>()
              .map((e) => Shop.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }
    }
    return const <Shop>[];
  }
}
