// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barber_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarberWorkingHourImpl _$$BarberWorkingHourImplFromJson(
  Map<String, dynamic> json,
) => _$BarberWorkingHourImpl(
  id: json['id'] == null ? '' : _idFromJson(json['id']),
  dayOfWeek: json['day_of_week'] == null
      ? 0
      : _dayOfWeekFromJson(json['day_of_week']),
  startTime: json['start_time'] as String? ?? '',
  endTime: json['end_time'] as String? ?? '',
  isWorking: json['is_working'] as bool? ?? false,
);

Map<String, dynamic> _$$BarberWorkingHourImplToJson(
  _$BarberWorkingHourImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'day_of_week': instance.dayOfWeek,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'is_working': instance.isWorking,
};

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
      hours:
          (json['hours'] as List<dynamic>?)
              ?.map(
                (e) => BarberWorkingHour.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <BarberWorkingHour>[],
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
      'hours': instance.hours,
    };
