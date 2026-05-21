import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gems_data_layer/gems_data_layer.dart';

import '../../utils/date_range_utils.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel implements BaseModel {
  const factory AppointmentModel({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    required AppointmentBarber barber,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'alternative_barber') AppointmentBarber? alternativeBarber,
    required AppointmentService service,
    AppointmentShop? shop,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson)
    DateTime? startsAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson) DateTime? endsAt,
    @Default('booked') String status,
    String? notes,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'recurring_group_id') String? recurringGroupId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}

/// Latest server-side change time for list ordering (newest first).
extension AppointmentModelActivitySort on AppointmentModel {
  DateTime get activitySortTime =>
      updatedAt ??
      createdAt ??
      startsAt ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

extension AppointmentModelListDisplay on AppointmentModel {
  String get primaryBarberName {
    final name = barber.name.trim();
    return name.isNotEmpty ? name : 'Barber';
  }

  String? get alternativeBarberName {
    final name = alternativeBarber?.name.trim() ?? '';
    return name.isNotEmpty ? name : null;
  }

  bool get hasAlternativeBarber => alternativeBarberName != null;
}

@freezed
class AppointmentBarber with _$AppointmentBarber {
  const factory AppointmentBarber({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String? phone,
    String? gender,
    String? avatar,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active', fromJson: _nullableBoolFromJson)
    @Default(false)
    bool isActive,
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

@freezed
class AppointmentShop with _$AppointmentShop {
  const factory AppointmentShop({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _idFromJson) required String id,
    @Default('') String name,
    @Default('') String address,
    @Default('') String phone,
    @Default('') String email,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'is_active') @Default(false) bool isActive,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _nullableDoubleFromJson) double? latitude,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _nullableDoubleFromJson) double? longitude,
  }) = _AppointmentShop;

  factory AppointmentShop.fromJson(Map<String, dynamic> json) =>
      _$AppointmentShopFromJson(json);
}

/// Typed request DTO for `POST /appointments`.
@freezed
class AppointmentBookingRequest with _$AppointmentBookingRequest {
  const factory AppointmentBookingRequest({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'shop_id') required int shopId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'barber_id') required int barberId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'service_id') required int serviceId,
    required String date,
    required String time,
    @Default('') String notes,
  }) = _AppointmentBookingRequest;

  factory AppointmentBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentBookingRequestFromJson(json);
}

/// Cadence supported by `POST /appointments/recurring`.
///
/// Wire format is the lowercase enum name (`daily` / `weekly` / `monthly` / `times`).
enum RecurringRepeatType {
  @JsonValue('daily') daily,
  @JsonValue('weekly') weekly,
  @JsonValue('monthly') monthly,
  @JsonValue('times') times,
}

/// `repeat` sub-object on the recurring booking request.
///
/// [value] is the API's `min:1, max:52` field; for `daily`/`weekly`/`monthly`
/// it represents the number of repetitions, for `times` the literal count.
@freezed
class RecurringRepeat with _$RecurringRepeat {
  const factory RecurringRepeat({
    required RecurringRepeatType type,
    required int value,
  }) = _RecurringRepeat;

  factory RecurringRepeat.fromJson(Map<String, dynamic> json) =>
      _$RecurringRepeatFromJson(json);
}

/// Typed request DTO for `POST /appointments/recurring`.
@freezed
class RecurringAppointmentRequest with _$RecurringAppointmentRequest {
  const factory RecurringAppointmentRequest({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'shop_id') required int shopId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'barber_id') required int barberId,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'service_id') required int serviceId,
    required String date,
    required String time,
    String? notes,
    required RecurringRepeat repeat,
  }) = _RecurringAppointmentRequest;

  factory RecurringAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$RecurringAppointmentRequestFromJson(json);
}

/// One item from `data.skipped[]` in the recurring response.
@freezed
class RecurringSkippedSlot with _$RecurringSkippedSlot {
  const factory RecurringSkippedSlot({
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _dateTimeFromJson) DateTime? datetime,
    @Default('') String reason,
  }) = _RecurringSkippedSlot;

  factory RecurringSkippedSlot.fromJson(Map<String, dynamic> json) =>
      _$RecurringSkippedSlotFromJson(json);
}

/// Parsed `data` envelope from `POST /appointments/recurring`.
@freezed
class RecurringAppointmentResult with _$RecurringAppointmentResult {
  const factory RecurringAppointmentResult({
    @Default(<AppointmentModel>[]) List<AppointmentModel> booked,
    @Default(<RecurringSkippedSlot>[]) List<RecurringSkippedSlot> skipped,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'recurring_group_id') String? recurringGroupId,
  }) = _RecurringAppointmentResult;

  factory RecurringAppointmentResult.fromJson(Map<String, dynamic> json) =>
      _$RecurringAppointmentResultFromJson(json);
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

double? _nullableDoubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String && value.isNotEmpty) return double.tryParse(value);
  return null;
}

bool _nullableBoolFromJson(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  if (value is num) return value != 0;
  return false;
}

DateTime? _dateTimeFromJson(dynamic value) => parseApiWallClockDateTime(value);
