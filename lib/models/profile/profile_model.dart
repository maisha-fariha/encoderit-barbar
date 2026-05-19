import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel implements BaseModel {
  const factory ProfileModel({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    String? avatar,
    @Default('') String role,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'selected_shop_id', fromJson: _nullableIdFromJson)
    String? selectedShopId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'email_verified_at', fromJson: _dateTimeFromJson)
    DateTime? emailVerifiedAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}

String? _nullableIdFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value.toString();
  if (value is String) return value.isEmpty ? null : value;
  return value.toString();
}

DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

extension ProfileDisplay on ProfileModel {
  bool get isEmailVerified => emailVerifiedAt != null;
  bool get hasAvatar => (avatar ?? '').isNotEmpty;
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
