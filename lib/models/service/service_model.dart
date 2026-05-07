import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel implements BaseModel {
  const factory ServiceModel({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    String? description,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _priceFromJson) @Default(0) double price,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'duration_minutes') @Default(0) int durationMinutes,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}

double _priceFromJson(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
