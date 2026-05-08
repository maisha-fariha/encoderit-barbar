import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel implements BaseModel {
  const factory AppointmentModel({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    required AppointmentBarber barber,
    required AppointmentService service,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'starts_at') DateTime? startsAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'ends_at') DateTime? endsAt,
    @Default('booked') String status,
    String? notes,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}

@freezed
class AppointmentBarber with _$AppointmentBarber {
  const factory AppointmentBarber({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String? phone,
  }) = _AppointmentBarber;

  factory AppointmentBarber.fromJson(Map<String, dynamic> json) =>
      _$AppointmentBarberFromJson(json);
}

@freezed
class AppointmentService with _$AppointmentService {
  const factory AppointmentService({
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
  }) = _AppointmentService;

  factory AppointmentService.fromJson(Map<String, dynamic> json) =>
      _$AppointmentServiceFromJson(json);
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
