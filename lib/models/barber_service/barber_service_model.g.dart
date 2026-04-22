// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barber_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarberServiceImpl _$$BarberServiceImplFromJson(Map<String, dynamic> json) =>
    _$BarberServiceImpl(
      id: _idFromJson(json['id']),
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '',
      pantoneValue: json['pantone_value'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BarberServiceImplToJson(_$BarberServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'pantone_value': instance.pantoneValue,
      'year': instance.year,
    };
