// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barbar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarbarImpl _$$BarbarImplFromJson(Map<String, dynamic> json) => _$BarbarImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String,
  username: json['username'] as String? ?? '',
);

Map<String, dynamic> _$$BarbarImplToJson(_$BarbarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
    };
