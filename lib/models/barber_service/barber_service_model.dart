import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

part 'barber_service_model.freezed.dart';
part 'barber_service_model.g.dart';

/// Domain row for the barber services list (demo API: ReqRes products shape).
@freezed
class BarberService with _$BarberService implements BaseModel {
  const factory BarberService({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    @Default('') String color,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'pantone_value') @Default('') String pantoneValue,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'year') @Default(0) int year,
  }) = _BarberService;

  factory BarberService.fromJson(Map<String, dynamic> json) =>
      _$BarberServiceFromJson(json);
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}

extension BarberServiceDisplay on BarberService {
  String get displayTitle => name.isNotEmpty ? name : 'Service $id';

  String get displaySubtitle {
    if (pantoneValue.isNotEmpty) return pantoneValue;
    if (color.isNotEmpty) return color;
    if (year != 0) return year.toString();
    return '';
  }
}
