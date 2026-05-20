// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barber_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BarberWorkingHour _$BarberWorkingHourFromJson(Map<String, dynamic> json) {
  return _BarberWorkingHour.fromJson(json);
}

/// @nodoc
mixin _$BarberWorkingHour {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError; // API: 0 = Sunday, 1 = Monday, … 6 = Saturday.
  // ignore: invalid_annotation_target
  @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson)
  int get dayOfWeek => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_working')
  bool get isWorking => throw _privateConstructorUsedError;

  /// Serializes this BarberWorkingHour to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BarberWorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarberWorkingHourCopyWith<BarberWorkingHour> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarberWorkingHourCopyWith<$Res> {
  factory $BarberWorkingHourCopyWith(
    BarberWorkingHour value,
    $Res Function(BarberWorkingHour) then,
  ) = _$BarberWorkingHourCopyWithImpl<$Res, BarberWorkingHour>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson) int dayOfWeek,
    @JsonKey(name: 'start_time') String startTime,
    @JsonKey(name: 'end_time') String endTime,
    @JsonKey(name: 'is_working') bool isWorking,
  });
}

/// @nodoc
class _$BarberWorkingHourCopyWithImpl<$Res, $Val extends BarberWorkingHour>
    implements $BarberWorkingHourCopyWith<$Res> {
  _$BarberWorkingHourCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BarberWorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isWorking = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            dayOfWeek: null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            isWorking: null == isWorking
                ? _value.isWorking
                : isWorking // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BarberWorkingHourImplCopyWith<$Res>
    implements $BarberWorkingHourCopyWith<$Res> {
  factory _$$BarberWorkingHourImplCopyWith(
    _$BarberWorkingHourImpl value,
    $Res Function(_$BarberWorkingHourImpl) then,
  ) = __$$BarberWorkingHourImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson) int dayOfWeek,
    @JsonKey(name: 'start_time') String startTime,
    @JsonKey(name: 'end_time') String endTime,
    @JsonKey(name: 'is_working') bool isWorking,
  });
}

/// @nodoc
class __$$BarberWorkingHourImplCopyWithImpl<$Res>
    extends _$BarberWorkingHourCopyWithImpl<$Res, _$BarberWorkingHourImpl>
    implements _$$BarberWorkingHourImplCopyWith<$Res> {
  __$$BarberWorkingHourImplCopyWithImpl(
    _$BarberWorkingHourImpl _value,
    $Res Function(_$BarberWorkingHourImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BarberWorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isWorking = null,
  }) {
    return _then(
      _$BarberWorkingHourImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dayOfWeek: null == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        isWorking: null == isWorking
            ? _value.isWorking
            : isWorking // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BarberWorkingHourImpl implements _BarberWorkingHour {
  const _$BarberWorkingHourImpl({
    @JsonKey(fromJson: _idFromJson) this.id = '',
    @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson)
    this.dayOfWeek = 0,
    @JsonKey(name: 'start_time') this.startTime = '',
    @JsonKey(name: 'end_time') this.endTime = '',
    @JsonKey(name: 'is_working') this.isWorking = false,
  });

  factory _$BarberWorkingHourImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarberWorkingHourImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  // API: 0 = Sunday, 1 = Monday, … 6 = Saturday.
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson)
  final int dayOfWeek;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_working')
  final bool isWorking;

  @override
  String toString() {
    return 'BarberWorkingHour(id: $id, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, isWorking: $isWorking)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarberWorkingHourImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isWorking, isWorking) ||
                other.isWorking == isWorking));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, dayOfWeek, startTime, endTime, isWorking);

  /// Create a copy of BarberWorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarberWorkingHourImplCopyWith<_$BarberWorkingHourImpl> get copyWith =>
      __$$BarberWorkingHourImplCopyWithImpl<_$BarberWorkingHourImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BarberWorkingHourImplToJson(this);
  }
}

abstract class _BarberWorkingHour implements BarberWorkingHour {
  const factory _BarberWorkingHour({
    @JsonKey(fromJson: _idFromJson) final String id,
    @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson)
    final int dayOfWeek,
    @JsonKey(name: 'start_time') final String startTime,
    @JsonKey(name: 'end_time') final String endTime,
    @JsonKey(name: 'is_working') final bool isWorking,
  }) = _$BarberWorkingHourImpl;

  factory _BarberWorkingHour.fromJson(Map<String, dynamic> json) =
      _$BarberWorkingHourImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  String get id; // API: 0 = Sunday, 1 = Monday, … 6 = Saturday.
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'day_of_week', fromJson: _dayOfWeekFromJson)
  int get dayOfWeek; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'start_time')
  String get startTime; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'end_time')
  String get endTime; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_working')
  bool get isWorking;

  /// Create a copy of BarberWorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarberWorkingHourImplCopyWith<_$BarberWorkingHourImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BarberModel _$BarberModelFromJson(Map<String, dynamic> json) {
  return _BarberModel.fromJson(json);
}

/// @nodoc
mixin _$BarberModel {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get avatar =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  List<ServiceModel> get services => throw _privateConstructorUsedError;
  List<BarberWorkingHour> get hours => throw _privateConstructorUsedError;

  /// Serializes this BarberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BarberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarberModelCopyWith<BarberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarberModelCopyWith<$Res> {
  factory $BarberModelCopyWith(
    BarberModel value,
    $Res Function(BarberModel) then,
  ) = _$BarberModelCopyWithImpl<$Res, BarberModel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String email,
    String phone,
    String? gender,
    String? avatar,
    @JsonKey(name: 'is_active') bool isActive,
    List<ServiceModel> services,
    List<BarberWorkingHour> hours,
  });
}

/// @nodoc
class _$BarberModelCopyWithImpl<$Res, $Val extends BarberModel>
    implements $BarberModelCopyWith<$Res> {
  _$BarberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BarberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? gender = freezed,
    Object? avatar = freezed,
    Object? isActive = null,
    Object? services = null,
    Object? hours = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            services: null == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<ServiceModel>,
            hours: null == hours
                ? _value.hours
                : hours // ignore: cast_nullable_to_non_nullable
                      as List<BarberWorkingHour>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BarberModelImplCopyWith<$Res>
    implements $BarberModelCopyWith<$Res> {
  factory _$$BarberModelImplCopyWith(
    _$BarberModelImpl value,
    $Res Function(_$BarberModelImpl) then,
  ) = __$$BarberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String email,
    String phone,
    String? gender,
    String? avatar,
    @JsonKey(name: 'is_active') bool isActive,
    List<ServiceModel> services,
    List<BarberWorkingHour> hours,
  });
}

/// @nodoc
class __$$BarberModelImplCopyWithImpl<$Res>
    extends _$BarberModelCopyWithImpl<$Res, _$BarberModelImpl>
    implements _$$BarberModelImplCopyWith<$Res> {
  __$$BarberModelImplCopyWithImpl(
    _$BarberModelImpl _value,
    $Res Function(_$BarberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BarberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? gender = freezed,
    Object? avatar = freezed,
    Object? isActive = null,
    Object? services = null,
    Object? hours = null,
  }) {
    return _then(
      _$BarberModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<ServiceModel>,
        hours: null == hours
            ? _value._hours
            : hours // ignore: cast_nullable_to_non_nullable
                  as List<BarberWorkingHour>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BarberModelImpl implements _BarberModel {
  const _$BarberModelImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.gender,
    this.avatar,
    @JsonKey(name: 'is_active') this.isActive = false,
    final List<ServiceModel> services = const <ServiceModel>[],
    final List<BarberWorkingHour> hours = const <BarberWorkingHour>[],
  }) : _services = services,
       _hours = hours;

  factory _$BarberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarberModelImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phone;
  @override
  final String? gender;
  @override
  final String? avatar;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<ServiceModel> _services;
  @override
  @JsonKey()
  List<ServiceModel> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  final List<BarberWorkingHour> _hours;
  @override
  @JsonKey()
  List<BarberWorkingHour> get hours {
    if (_hours is EqualUnmodifiableListView) return _hours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hours);
  }

  @override
  String toString() {
    return 'BarberModel(id: $id, name: $name, email: $email, phone: $phone, gender: $gender, avatar: $avatar, isActive: $isActive, services: $services, hours: $hours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            const DeepCollectionEquality().equals(other._hours, _hours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    phone,
    gender,
    avatar,
    isActive,
    const DeepCollectionEquality().hash(_services),
    const DeepCollectionEquality().hash(_hours),
  );

  /// Create a copy of BarberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarberModelImplCopyWith<_$BarberModelImpl> get copyWith =>
      __$$BarberModelImplCopyWithImpl<_$BarberModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BarberModelImplToJson(this);
  }
}

abstract class _BarberModel implements BarberModel {
  const factory _BarberModel({
    @JsonKey(fromJson: _idFromJson) required final String id,
    final String name,
    final String email,
    final String phone,
    final String? gender,
    final String? avatar,
    @JsonKey(name: 'is_active') final bool isActive,
    final List<ServiceModel> services,
    final List<BarberWorkingHour> hours,
  }) = _$BarberModelImpl;

  factory _BarberModel.fromJson(Map<String, dynamic> json) =
      _$BarberModelImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get phone;
  @override
  String? get gender;
  @override
  String? get avatar; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  List<ServiceModel> get services;
  @override
  List<BarberWorkingHour> get hours;

  /// Create a copy of BarberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarberModelImplCopyWith<_$BarberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
