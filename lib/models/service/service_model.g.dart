// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceModelImpl _$$ServiceModelImplFromJson(Map<String, dynamic> json) =>
    _$ServiceModelImpl(
      id: _idFromJson(json['id']),
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: json['price'] == null ? 0 : _priceFromJson(json['price']),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      showPrice: json['show_price'] as bool? ?? true,
    );

Map<String, dynamic> _$$ServiceModelImplToJson(_$ServiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'duration_minutes': instance.durationMinutes,
      'is_active': instance.isActive,
      'show_price': instance.showPrice,
    };
