// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentModelImpl _$$AppointmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentModelImpl(
  id: _idFromJson(json['id']),
  barber: AppointmentBarber.fromJson(json['barber'] as Map<String, dynamic>),
  service: AppointmentService.fromJson(json['service'] as Map<String, dynamic>),
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
  status: json['status'] as String? ?? 'booked',
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
  _$AppointmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'barber': instance.barber,
  'service': instance.service,
  'starts_at': instance.startsAt?.toIso8601String(),
  'ends_at': instance.endsAt?.toIso8601String(),
  'status': instance.status,
  'notes': instance.notes,
  'created_at': instance.createdAt?.toIso8601String(),
};

_$AppointmentBarberImpl _$$AppointmentBarberImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentBarberImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
);

Map<String, dynamic> _$$AppointmentBarberImplToJson(
  _$AppointmentBarberImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
};

_$AppointmentServiceImpl _$$AppointmentServiceImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentServiceImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String? ?? '',
  description: json['description'] as String?,
  price: json['price'] == null ? 0 : _priceFromJson(json['price']),
  durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? false,
);

Map<String, dynamic> _$$AppointmentServiceImplToJson(
  _$AppointmentServiceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'duration_minutes': instance.durationMinutes,
  'is_active': instance.isActive,
};
