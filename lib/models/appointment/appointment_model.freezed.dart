// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) {
  return _AppointmentModel.fromJson(json);
}

/// @nodoc
mixin _$AppointmentModel {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  AppointmentBarber get barber => throw _privateConstructorUsedError;
  AppointmentService get service =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'starts_at')
  DateTime? get startsAt => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'ends_at')
  DateTime? get endsAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AppointmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentModelCopyWith<AppointmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentModelCopyWith<$Res> {
  factory $AppointmentModelCopyWith(
    AppointmentModel value,
    $Res Function(AppointmentModel) then,
  ) = _$AppointmentModelCopyWithImpl<$Res, AppointmentModel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    AppointmentBarber barber,
    AppointmentService service,
    @JsonKey(name: 'starts_at') DateTime? startsAt,
    @JsonKey(name: 'ends_at') DateTime? endsAt,
    String status,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });

  $AppointmentBarberCopyWith<$Res> get barber;
  $AppointmentServiceCopyWith<$Res> get service;
}

/// @nodoc
class _$AppointmentModelCopyWithImpl<$Res, $Val extends AppointmentModel>
    implements $AppointmentModelCopyWith<$Res> {
  _$AppointmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? barber = null,
    Object? service = null,
    Object? startsAt = freezed,
    Object? endsAt = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            barber: null == barber
                ? _value.barber
                : barber // ignore: cast_nullable_to_non_nullable
                      as AppointmentBarber,
            service: null == service
                ? _value.service
                : service // ignore: cast_nullable_to_non_nullable
                      as AppointmentService,
            startsAt: freezed == startsAt
                ? _value.startsAt
                : startsAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endsAt: freezed == endsAt
                ? _value.endsAt
                : endsAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppointmentBarberCopyWith<$Res> get barber {
    return $AppointmentBarberCopyWith<$Res>(_value.barber, (value) {
      return _then(_value.copyWith(barber: value) as $Val);
    });
  }

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppointmentServiceCopyWith<$Res> get service {
    return $AppointmentServiceCopyWith<$Res>(_value.service, (value) {
      return _then(_value.copyWith(service: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppointmentModelImplCopyWith<$Res>
    implements $AppointmentModelCopyWith<$Res> {
  factory _$$AppointmentModelImplCopyWith(
    _$AppointmentModelImpl value,
    $Res Function(_$AppointmentModelImpl) then,
  ) = __$$AppointmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    AppointmentBarber barber,
    AppointmentService service,
    @JsonKey(name: 'starts_at') DateTime? startsAt,
    @JsonKey(name: 'ends_at') DateTime? endsAt,
    String status,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });

  @override
  $AppointmentBarberCopyWith<$Res> get barber;
  @override
  $AppointmentServiceCopyWith<$Res> get service;
}

/// @nodoc
class __$$AppointmentModelImplCopyWithImpl<$Res>
    extends _$AppointmentModelCopyWithImpl<$Res, _$AppointmentModelImpl>
    implements _$$AppointmentModelImplCopyWith<$Res> {
  __$$AppointmentModelImplCopyWithImpl(
    _$AppointmentModelImpl _value,
    $Res Function(_$AppointmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? barber = null,
    Object? service = null,
    Object? startsAt = freezed,
    Object? endsAt = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$AppointmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        barber: null == barber
            ? _value.barber
            : barber // ignore: cast_nullable_to_non_nullable
                  as AppointmentBarber,
        service: null == service
            ? _value.service
            : service // ignore: cast_nullable_to_non_nullable
                  as AppointmentService,
        startsAt: freezed == startsAt
            ? _value.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endsAt: freezed == endsAt
            ? _value.endsAt
            : endsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentModelImpl implements _AppointmentModel {
  const _$AppointmentModelImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    required this.barber,
    required this.service,
    @JsonKey(name: 'starts_at') this.startsAt,
    @JsonKey(name: 'ends_at') this.endsAt,
    this.status = 'booked',
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$AppointmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentModelImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  @override
  final AppointmentBarber barber;
  @override
  final AppointmentService service;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'starts_at')
  final DateTime? startsAt;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'ends_at')
  final DateTime? endsAt;
  @override
  @JsonKey()
  final String status;
  @override
  final String? notes;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AppointmentModel(id: $id, barber: $barber, service: $service, startsAt: $startsAt, endsAt: $endsAt, status: $status, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barber, barber) || other.barber == barber) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    barber,
    service,
    startsAt,
    endsAt,
    status,
    notes,
    createdAt,
  );

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      __$$AppointmentModelImplCopyWithImpl<_$AppointmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentModelImplToJson(this);
  }
}

abstract class _AppointmentModel implements AppointmentModel {
  const factory _AppointmentModel({
    @JsonKey(fromJson: _idFromJson) required final String id,
    required final AppointmentBarber barber,
    required final AppointmentService service,
    @JsonKey(name: 'starts_at') final DateTime? startsAt,
    @JsonKey(name: 'ends_at') final DateTime? endsAt,
    final String status,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$AppointmentModelImpl;

  factory _AppointmentModel.fromJson(Map<String, dynamic> json) =
      _$AppointmentModelImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  AppointmentBarber get barber;
  @override
  AppointmentService get service; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'starts_at')
  DateTime? get startsAt; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'ends_at')
  DateTime? get endsAt;
  @override
  String get status;
  @override
  String? get notes; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentModelImplCopyWith<_$AppointmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppointmentBarber _$AppointmentBarberFromJson(Map<String, dynamic> json) {
  return _AppointmentBarber.fromJson(json);
}

/// @nodoc
mixin _$AppointmentBarber {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this AppointmentBarber to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentBarber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentBarberCopyWith<AppointmentBarber> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentBarberCopyWith<$Res> {
  factory $AppointmentBarberCopyWith(
    AppointmentBarber value,
    $Res Function(AppointmentBarber) then,
  ) = _$AppointmentBarberCopyWithImpl<$Res, AppointmentBarber>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String email,
    String? phone,
  });
}

/// @nodoc
class _$AppointmentBarberCopyWithImpl<$Res, $Val extends AppointmentBarber>
    implements $AppointmentBarberCopyWith<$Res> {
  _$AppointmentBarberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentBarber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
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
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentBarberImplCopyWith<$Res>
    implements $AppointmentBarberCopyWith<$Res> {
  factory _$$AppointmentBarberImplCopyWith(
    _$AppointmentBarberImpl value,
    $Res Function(_$AppointmentBarberImpl) then,
  ) = __$$AppointmentBarberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String email,
    String? phone,
  });
}

/// @nodoc
class __$$AppointmentBarberImplCopyWithImpl<$Res>
    extends _$AppointmentBarberCopyWithImpl<$Res, _$AppointmentBarberImpl>
    implements _$$AppointmentBarberImplCopyWith<$Res> {
  __$$AppointmentBarberImplCopyWithImpl(
    _$AppointmentBarberImpl _value,
    $Res Function(_$AppointmentBarberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentBarber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = freezed,
  }) {
    return _then(
      _$AppointmentBarberImpl(
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
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentBarberImpl implements _AppointmentBarber {
  const _$AppointmentBarberImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
  });

  factory _$AppointmentBarberImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentBarberImplFromJson(json);

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
  final String? phone;

  @override
  String toString() {
    return 'AppointmentBarber(id: $id, name: $name, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentBarberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, phone);

  /// Create a copy of AppointmentBarber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentBarberImplCopyWith<_$AppointmentBarberImpl> get copyWith =>
      __$$AppointmentBarberImplCopyWithImpl<_$AppointmentBarberImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentBarberImplToJson(this);
  }
}

abstract class _AppointmentBarber implements AppointmentBarber {
  const factory _AppointmentBarber({
    @JsonKey(fromJson: _idFromJson) required final String id,
    final String name,
    final String email,
    final String? phone,
  }) = _$AppointmentBarberImpl;

  factory _AppointmentBarber.fromJson(Map<String, dynamic> json) =
      _$AppointmentBarberImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String? get phone;

  /// Create a copy of AppointmentBarber
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentBarberImplCopyWith<_$AppointmentBarberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppointmentService _$AppointmentServiceFromJson(Map<String, dynamic> json) {
  return _AppointmentService.fromJson(json);
}

/// @nodoc
mixin _$AppointmentService {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _priceFromJson)
  double get price => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this AppointmentService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentServiceCopyWith<AppointmentService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentServiceCopyWith<$Res> {
  factory $AppointmentServiceCopyWith(
    AppointmentService value,
    $Res Function(AppointmentService) then,
  ) = _$AppointmentServiceCopyWithImpl<$Res, AppointmentService>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String? description,
    @JsonKey(fromJson: _priceFromJson) double price,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$AppointmentServiceCopyWithImpl<$Res, $Val extends AppointmentService>
    implements $AppointmentServiceCopyWith<$Res> {
  _$AppointmentServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? isActive = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentServiceImplCopyWith<$Res>
    implements $AppointmentServiceCopyWith<$Res> {
  factory _$$AppointmentServiceImplCopyWith(
    _$AppointmentServiceImpl value,
    $Res Function(_$AppointmentServiceImpl) then,
  ) = __$$AppointmentServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String? description,
    @JsonKey(fromJson: _priceFromJson) double price,
    @JsonKey(name: 'duration_minutes') int durationMinutes,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$AppointmentServiceImplCopyWithImpl<$Res>
    extends _$AppointmentServiceCopyWithImpl<$Res, _$AppointmentServiceImpl>
    implements _$$AppointmentServiceImplCopyWith<$Res> {
  __$$AppointmentServiceImplCopyWithImpl(
    _$AppointmentServiceImpl _value,
    $Res Function(_$AppointmentServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? price = null,
    Object? durationMinutes = null,
    Object? isActive = null,
  }) {
    return _then(
      _$AppointmentServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentServiceImpl implements _AppointmentService {
  const _$AppointmentServiceImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    this.name = '',
    this.description,
    @JsonKey(fromJson: _priceFromJson) this.price = 0,
    @JsonKey(name: 'duration_minutes') this.durationMinutes = 0,
    @JsonKey(name: 'is_active') this.isActive = false,
  });

  factory _$AppointmentServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentServiceImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  final String? description;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _priceFromJson)
  final double price;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'AppointmentService(id: $id, name: $name, description: $description, price: $price, durationMinutes: $durationMinutes, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    price,
    durationMinutes,
    isActive,
  );

  /// Create a copy of AppointmentService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentServiceImplCopyWith<_$AppointmentServiceImpl> get copyWith =>
      __$$AppointmentServiceImplCopyWithImpl<_$AppointmentServiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentServiceImplToJson(this);
  }
}

abstract class _AppointmentService implements AppointmentService {
  const factory _AppointmentService({
    @JsonKey(fromJson: _idFromJson) required final String id,
    final String name,
    final String? description,
    @JsonKey(fromJson: _priceFromJson) final double price,
    @JsonKey(name: 'duration_minutes') final int durationMinutes,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$AppointmentServiceImpl;

  factory _AppointmentService.fromJson(Map<String, dynamic> json) =
      _$AppointmentServiceImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get description; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _priceFromJson)
  double get price; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of AppointmentService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentServiceImplCopyWith<_$AppointmentServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
