// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopImpl _$$ShopImplFromJson(Map<String, dynamic> json) => _$ShopImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String? ?? '',
  address: json['address'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  email: json['email'] as String? ?? '',
  isActive: json['is_active'] as bool? ?? false,
  services:
      (json['services'] as List<dynamic>?)
          ?.map((e) => ShopService.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ShopService>[],
);

Map<String, dynamic> _$$ShopImplToJson(_$ShopImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'is_active': instance.isActive,
      'services': instance.services,
    };

_$ShopServiceImpl _$$ShopServiceImplFromJson(Map<String, dynamic> json) =>
    _$ShopServiceImpl(
      id: _idFromJson(json['id']),
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: json['price'] == null ? 0 : _priceFromJson(json['price']),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? false,
    );

Map<String, dynamic> _$$ShopServiceImplToJson(_$ShopServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'duration_minutes': instance.durationMinutes,
      'is_active': instance.isActive,
    };
