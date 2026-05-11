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
  shop: json['shop'] == null
      ? null
      : AppointmentShop.fromJson(json['shop'] as Map<String, dynamic>),
  startsAt: _dateTimeFromJson(json['starts_at']),
  endsAt: _dateTimeFromJson(json['ends_at']),
  status: json['status'] as String? ?? 'booked',
  notes: json['notes'] as String?,
  recurringGroupId: json['recurring_group_id'] as String?,
  createdAt: _dateTimeFromJson(json['created_at']),
);

Map<String, dynamic> _$$AppointmentModelImplToJson(
  _$AppointmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'barber': instance.barber,
  'service': instance.service,
  'shop': instance.shop,
  'starts_at': instance.startsAt?.toIso8601String(),
  'ends_at': instance.endsAt?.toIso8601String(),
  'status': instance.status,
  'notes': instance.notes,
  'recurring_group_id': instance.recurringGroupId,
  'created_at': instance.createdAt?.toIso8601String(),
};

_$AppointmentBarberImpl _$$AppointmentBarberImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentBarberImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  gender: json['gender'] as String?,
  avatar: json['avatar'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  isActive: json['is_active'] as bool? ?? false,
);

Map<String, dynamic> _$$AppointmentBarberImplToJson(
  _$AppointmentBarberImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'gender': instance.gender,
  'avatar': instance.avatar,
  'avatar_url': instance.avatarUrl,
  'is_active': instance.isActive,
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

_$AppointmentShopImpl _$$AppointmentShopImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentShopImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String? ?? '',
  address: json['address'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  email: json['email'] as String? ?? '',
  isActive: json['is_active'] as bool? ?? false,
  latitude: _nullableDoubleFromJson(json['latitude']),
  longitude: _nullableDoubleFromJson(json['longitude']),
);

Map<String, dynamic> _$$AppointmentShopImplToJson(
  _$AppointmentShopImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'phone': instance.phone,
  'email': instance.email,
  'is_active': instance.isActive,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

_$AppointmentBookingRequestImpl _$$AppointmentBookingRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AppointmentBookingRequestImpl(
  shopId: (json['shop_id'] as num).toInt(),
  barberId: (json['barber_id'] as num).toInt(),
  serviceId: (json['service_id'] as num).toInt(),
  date: json['date'] as String,
  time: json['time'] as String,
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$$AppointmentBookingRequestImplToJson(
  _$AppointmentBookingRequestImpl instance,
) => <String, dynamic>{
  'shop_id': instance.shopId,
  'barber_id': instance.barberId,
  'service_id': instance.serviceId,
  'date': instance.date,
  'time': instance.time,
  'notes': instance.notes,
};

_$RecurringRepeatImpl _$$RecurringRepeatImplFromJson(
  Map<String, dynamic> json,
) => _$RecurringRepeatImpl(
  type: $enumDecode(_$RecurringRepeatTypeEnumMap, json['type']),
  value: (json['value'] as num).toInt(),
);

Map<String, dynamic> _$$RecurringRepeatImplToJson(
  _$RecurringRepeatImpl instance,
) => <String, dynamic>{
  'type': _$RecurringRepeatTypeEnumMap[instance.type]!,
  'value': instance.value,
};

const _$RecurringRepeatTypeEnumMap = {
  RecurringRepeatType.daily: 'daily',
  RecurringRepeatType.weekly: 'weekly',
  RecurringRepeatType.monthly: 'monthly',
  RecurringRepeatType.times: 'times',
};

_$RecurringAppointmentRequestImpl _$$RecurringAppointmentRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RecurringAppointmentRequestImpl(
  shopId: (json['shop_id'] as num).toInt(),
  barberId: (json['barber_id'] as num).toInt(),
  serviceId: (json['service_id'] as num).toInt(),
  date: json['date'] as String,
  time: json['time'] as String,
  notes: json['notes'] as String?,
  repeat: RecurringRepeat.fromJson(json['repeat'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$RecurringAppointmentRequestImplToJson(
  _$RecurringAppointmentRequestImpl instance,
) => <String, dynamic>{
  'shop_id': instance.shopId,
  'barber_id': instance.barberId,
  'service_id': instance.serviceId,
  'date': instance.date,
  'time': instance.time,
  'notes': instance.notes,
  'repeat': instance.repeat,
};

_$RecurringSkippedSlotImpl _$$RecurringSkippedSlotImplFromJson(
  Map<String, dynamic> json,
) => _$RecurringSkippedSlotImpl(
  datetime: _dateTimeFromJson(json['datetime']),
  reason: json['reason'] as String? ?? '',
);

Map<String, dynamic> _$$RecurringSkippedSlotImplToJson(
  _$RecurringSkippedSlotImpl instance,
) => <String, dynamic>{
  'datetime': instance.datetime?.toIso8601String(),
  'reason': instance.reason,
};

_$RecurringAppointmentResultImpl _$$RecurringAppointmentResultImplFromJson(
  Map<String, dynamic> json,
) => _$RecurringAppointmentResultImpl(
  booked:
      (json['booked'] as List<dynamic>?)
          ?.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AppointmentModel>[],
  skipped:
      (json['skipped'] as List<dynamic>?)
          ?.map((e) => RecurringSkippedSlot.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecurringSkippedSlot>[],
  recurringGroupId: json['recurring_group_id'] as String?,
);

Map<String, dynamic> _$$RecurringAppointmentResultImplToJson(
  _$RecurringAppointmentResultImpl instance,
) => <String, dynamic>{
  'booked': instance.booked,
  'skipped': instance.skipped,
  'recurring_group_id': instance.recurringGroupId,
};
