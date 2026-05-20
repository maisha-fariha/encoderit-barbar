import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../service/service_model.dart';

part 'barber_model.freezed.dart';
part 'barber_model.g.dart';

@freezed
class BarberWorkingHour with _$BarberWorkingHour {
  const factory BarberWorkingHour({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) @Default('') String id,
    // API: 0 = Sunday, 1 = Monday, … 6 = Saturday.
    // ignore: invalid_annotation_target
    @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson)
    @Default(0)
    int dayOfWeek,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'start_time') @Default('') String startTime,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'end_time') @Default('') String endTime,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_working') @Default(false) bool isWorking,
  }) = _BarberWorkingHour;

  factory BarberWorkingHour.fromJson(Map<String, dynamic> json) =>
      _$BarberWorkingHourFromJson(json);
}

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
    @Default(<BarberWorkingHour>[]) List<BarberWorkingHour> hours,
  }) = _BarberModel;

  factory BarberModel.fromJson(Map<String, dynamic> json) =>
      _$BarberModelFromJson(json);
}

/// Maps [DateTime] to API `day_of_week` (0 = Sunday … 6 = Saturday).
int apiDayOfWeekFromDate(DateTime date) => date.weekday % 7;

extension BarberModelWorkingDays on BarberModel {
  /// Working days from [hours] where `is_working` is true.
  Set<int> get workingDayOfWeekValues => hours
      .where((h) => h.isWorking)
      .map((h) => h.dayOfWeek)
      .toSet();

  BarberWorkingHour? workingHourForDate(DateTime date) {
    final dow = apiDayOfWeekFromDate(date);
    for (final hour in hours) {
      if (hour.dayOfWeek == dow && hour.isWorking) return hour;
    }
    return null;
  }

  bool isWorkingDay(DateTime date) => workingHourForDate(date) != null;
}

String _idFromJson(dynamic value) {
  if (value is int) return value.toString();
  if (value is String) return value;
  return value?.toString() ?? '';
}

int _dayOfWeekFromJson(dynamic value) {
  if (value is int) return value.clamp(0, 6);
  if (value is String) return int.tryParse(value)?.clamp(0, 6) ?? 0;
  return 0;
}
