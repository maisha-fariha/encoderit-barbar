import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../service/service_model.dart';

part 'barber_model.freezed.dart';
part 'barber_model.g.dart';

@freezed
class BarberModel with _$BarberModel implements BaseModel {
  const factory BarberModel({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    String? gender,
    String? avatar,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    @Default(<ServiceModel>[]) List<ServiceModel> services,
  }) = _BarberModel;

  factory BarberModel.fromJson(Map<String, dynamic> json) =>
      _$BarberModelFromJson(json);
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}
