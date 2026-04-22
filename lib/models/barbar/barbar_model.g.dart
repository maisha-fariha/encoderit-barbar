// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barbar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarbarImpl _$$BarbarImplFromJson(Map<String, dynamic> json) => _$BarbarImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String? ?? '',
  firstName: json['first_name'] as String? ?? '',
  lastName: json['last_name'] as String? ?? '',
  username: json['username'] as String? ?? '',
  email: json['email'] as String? ?? '',
);

Map<String, dynamic> _$$BarbarImplToJson(_$BarbarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'username': instance.username,
      'email': instance.email,
    };
