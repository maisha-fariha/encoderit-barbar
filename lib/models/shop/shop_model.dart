import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';

@freezed
class Shop with _$Shop implements BaseModel {
  const factory Shop({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    @Default('') String address,
    @Default('') String phone,
    @Default('') String email,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson)
    double? latitude,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
    double? longitude,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    /// IANA timezone for this shop (e.g. `Europe/Rome`). Fallback: UTC.
    @Default('UTC') String timezone,
    @Default(<ShopService>[]) List<ShopService> services,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}

@freezed
class ShopService with _$ShopService {
  const factory ShopService({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    String? description,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _priceFromJson) @Default(0) double price,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'duration_minutes') @Default(0) int durationMinutes,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
  }) = _ShopService;

  factory ShopService.fromJson(Map<String, dynamic> json) =>
      _$ShopServiceFromJson(json);
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}

double _priceFromJson(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

double? _nullableDoubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

extension ShopDisplay on Shop {
  String get addressLine1 {
    if (address.isEmpty) return '';
    final idx = address.indexOf(',');
    if (idx <= 0) return address.trim();
    return address.substring(0, idx).trim();
  }

  String get addressLine2 {
    if (address.isEmpty) return '';
    final idx = address.indexOf(',');
    if (idx <= 0 || idx + 1 >= address.length) return '';
    return address.substring(idx + 1).trim();
  }

  /// True when API provided usable WGS84 coordinates for a map pin.
  bool get hasMapCoordinates {
    final lat = latitude;
    final lng = longitude;
    if (lat == null || lng == null) return false;
    if (!lat.isFinite || !lng.isFinite) return false;
    return lat.abs() <= 90 && lng.abs() <= 180;
  }
}
