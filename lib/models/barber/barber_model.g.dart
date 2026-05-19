// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barber_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarberModelImpl _$$BarberModelImplFromJson(Map<String, dynamic> json) =>
    _$BarberModelImpl(
      id: _idFromJson(json['id']),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      gender: json['gender'] as String?,
      avatar: json['avatar'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ServiceModel>[],
    );

Map<String, dynamic> _$$BarberModelImplToJson(_$BarberModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'avatar': instance.avatar,
      'is_active': instance.isActive,
      'services': instance.services,
    };
