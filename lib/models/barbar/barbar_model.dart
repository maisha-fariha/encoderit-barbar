import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

part 'barbar_model.freezed.dart';
part 'barbar_model.g.dart';

@freezed
class Barbar with _$Barbar implements BaseModel {
  const factory Barbar({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'first_name') @Default('') String firstName,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'last_name') @Default('') String lastName,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'username') @Default('') String username,
    @Default('') String email,
  }) = _Barbar;

  factory Barbar.fromJson(Map<String, dynamic> json) => _$BarbarFromJson(json);
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}

extension BarbarDisplay on Barbar {
  String get displayTitle {
    if (name.isNotEmpty) return name;
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) return combined;
    if (email.isNotEmpty) return email;
    return 'User $id';
  }

  String get displaySubtitle {
    if (username.isNotEmpty) return username;
    if (email.isNotEmpty) return email;
    return '';
  }
}
