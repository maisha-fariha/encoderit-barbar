import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

part 'barbar_model.freezed.dart';
part 'barbar_model.g.dart';

@freezed
class Barbar with _$Barbar implements BaseModel {
  const factory Barbar({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'username') @Default('') String username,
  }) = _Barbar;

  factory Barbar.fromJson(Map<String, dynamic> json) => _$BarbarFromJson(json);
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}
