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
  AppointmentService get service => throw _privateConstructorUsedError;
  AppointmentShop? get shop =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson)
  DateTime? get startsAt => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson)
  DateTime? get endsAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'recurring_group_id')
  String? get recurringGroupId => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
    AppointmentShop? shop,
    @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson) DateTime? startsAt,
    @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson) DateTime? endsAt,
    String status,
    String? notes,
    @JsonKey(name: 'recurring_group_id') String? recurringGroupId,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  });

  $AppointmentBarberCopyWith<$Res> get barber;
  $AppointmentServiceCopyWith<$Res> get service;
  $AppointmentShopCopyWith<$Res>? get shop;
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
    Object? shop = freezed,
    Object? startsAt = freezed,
    Object? endsAt = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? recurringGroupId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            shop: freezed == shop
                ? _value.shop
                : shop // ignore: cast_nullable_to_non_nullable
                      as AppointmentShop?,
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
            recurringGroupId: freezed == recurringGroupId
                ? _value.recurringGroupId
                : recurringGroupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of AppointmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppointmentShopCopyWith<$Res>? get shop {
    if (_value.shop == null) {
      return null;
    }

    return $AppointmentShopCopyWith<$Res>(_value.shop!, (value) {
      return _then(_value.copyWith(shop: value) as $Val);
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
    AppointmentShop? shop,
    @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson) DateTime? startsAt,
    @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson) DateTime? endsAt,
    String status,
    String? notes,
    @JsonKey(name: 'recurring_group_id') String? recurringGroupId,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  });

  @override
  $AppointmentBarberCopyWith<$Res> get barber;
  @override
  $AppointmentServiceCopyWith<$Res> get service;
  @override
  $AppointmentShopCopyWith<$Res>? get shop;
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
    Object? shop = freezed,
    Object? startsAt = freezed,
    Object? endsAt = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? recurringGroupId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
        shop: freezed == shop
            ? _value.shop
            : shop // ignore: cast_nullable_to_non_nullable
                  as AppointmentShop?,
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
        recurringGroupId: freezed == recurringGroupId
            ? _value.recurringGroupId
            : recurringGroupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
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
    this.shop,
    @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson) this.startsAt,
    @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson) this.endsAt,
    this.status = 'booked',
    this.notes,
    @JsonKey(name: 'recurring_group_id') this.recurringGroupId,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) this.createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson) this.updatedAt,
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
  @override
  final AppointmentShop? shop;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson)
  final DateTime? startsAt;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson)
  final DateTime? endsAt;
  @override
  @JsonKey()
  final String status;
  @override
  final String? notes;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'recurring_group_id')
  final String? recurringGroupId;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AppointmentModel(id: $id, barber: $barber, service: $service, shop: $shop, startsAt: $startsAt, endsAt: $endsAt, status: $status, notes: $notes, recurringGroupId: $recurringGroupId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barber, barber) || other.barber == barber) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.shop, shop) || other.shop == shop) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.recurringGroupId, recurringGroupId) ||
                other.recurringGroupId == recurringGroupId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    barber,
    service,
    shop,
    startsAt,
    endsAt,
    status,
    notes,
    recurringGroupId,
    createdAt,
    updatedAt,
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
    final AppointmentShop? shop,
    @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson)
    final DateTime? startsAt,
    @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson)
    final DateTime? endsAt,
    final String status,
    final String? notes,
    @JsonKey(name: 'recurring_group_id') final String? recurringGroupId,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    final DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    final DateTime? updatedAt,
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
  AppointmentService get service;
  @override
  AppointmentShop? get shop; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'starts_at', fromJson: _dateTimeFromJson)
  DateTime? get startsAt; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'ends_at', fromJson: _dateTimeFromJson)
  DateTime? get endsAt;
  @override
  String get status;
  @override
  String? get notes; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'recurring_group_id')
  String? get recurringGroupId; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  DateTime? get createdAt; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
  DateTime? get updatedAt;

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
  String? get gender => throw _privateConstructorUsedError;
  String? get avatar =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

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
    String? gender,
    String? avatar,
    @JsonKey(name: 'is_active') bool isActive,
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
    Object? gender = freezed,
    Object? avatar = freezed,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String? gender,
    String? avatar,
    @JsonKey(name: 'is_active') bool isActive,
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
    Object? gender = freezed,
    Object? avatar = freezed,
    Object? isActive = null,
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
    this.gender,
    this.avatar,
    @JsonKey(name: 'is_active') this.isActive = false,
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
  final String? gender;
  @override
  final String? avatar;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'AppointmentBarber(id: $id, name: $name, email: $email, phone: $phone, gender: $gender, avatar: $avatar, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentBarberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
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
  );

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
    final String? gender,
    final String? avatar,
    @JsonKey(name: 'is_active') final bool isActive,
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
  @override
  String? get gender;
  @override
  String? get avatar; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

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

AppointmentShop _$AppointmentShopFromJson(Map<String, dynamic> json) {
  return _AppointmentShop.fromJson(json);
}

/// @nodoc
mixin _$AppointmentShop {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _nullableDoubleFromJson)
  double? get latitude => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _nullableDoubleFromJson)
  double? get longitude => throw _privateConstructorUsedError;

  /// Serializes this AppointmentShop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentShop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentShopCopyWith<AppointmentShop> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentShopCopyWith<$Res> {
  factory $AppointmentShopCopyWith(
    AppointmentShop value,
    $Res Function(AppointmentShop) then,
  ) = _$AppointmentShopCopyWithImpl<$Res, AppointmentShop>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String address,
    String phone,
    String email,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(fromJson: _nullableDoubleFromJson) double? latitude,
    @JsonKey(fromJson: _nullableDoubleFromJson) double? longitude,
  });
}

/// @nodoc
class _$AppointmentShopCopyWithImpl<$Res, $Val extends AppointmentShop>
    implements $AppointmentShopCopyWith<$Res> {
  _$AppointmentShopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentShop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? email = null,
    Object? isActive = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
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
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentShopImplCopyWith<$Res>
    implements $AppointmentShopCopyWith<$Res> {
  factory _$$AppointmentShopImplCopyWith(
    _$AppointmentShopImpl value,
    $Res Function(_$AppointmentShopImpl) then,
  ) = __$$AppointmentShopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String address,
    String phone,
    String email,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(fromJson: _nullableDoubleFromJson) double? latitude,
    @JsonKey(fromJson: _nullableDoubleFromJson) double? longitude,
  });
}

/// @nodoc
class __$$AppointmentShopImplCopyWithImpl<$Res>
    extends _$AppointmentShopCopyWithImpl<$Res, _$AppointmentShopImpl>
    implements _$$AppointmentShopImplCopyWith<$Res> {
  __$$AppointmentShopImplCopyWithImpl(
    _$AppointmentShopImpl _value,
    $Res Function(_$AppointmentShopImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentShop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? email = null,
    Object? isActive = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      _$AppointmentShopImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentShopImpl implements _AppointmentShop {
  const _$AppointmentShopImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    this.name = '',
    this.address = '',
    this.phone = '',
    this.email = '',
    @JsonKey(name: 'is_active') this.isActive = false,
    @JsonKey(fromJson: _nullableDoubleFromJson) this.latitude,
    @JsonKey(fromJson: _nullableDoubleFromJson) this.longitude,
  });

  factory _$AppointmentShopImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentShopImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String email;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? latitude;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? longitude;

  @override
  String toString() {
    return 'AppointmentShop(id: $id, name: $name, address: $address, phone: $phone, email: $email, isActive: $isActive, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentShopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    phone,
    email,
    isActive,
    latitude,
    longitude,
  );

  /// Create a copy of AppointmentShop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentShopImplCopyWith<_$AppointmentShopImpl> get copyWith =>
      __$$AppointmentShopImplCopyWithImpl<_$AppointmentShopImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentShopImplToJson(this);
  }
}

abstract class _AppointmentShop implements AppointmentShop {
  const factory _AppointmentShop({
    @JsonKey(fromJson: _idFromJson) required final String id,
    final String name,
    final String address,
    final String phone,
    final String email,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(fromJson: _nullableDoubleFromJson) final double? latitude,
    @JsonKey(fromJson: _nullableDoubleFromJson) final double? longitude,
  }) = _$AppointmentShopImpl;

  factory _AppointmentShop.fromJson(Map<String, dynamic> json) =
      _$AppointmentShopImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  String get phone;
  @override
  String get email; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  bool get isActive; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _nullableDoubleFromJson)
  double? get latitude; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _nullableDoubleFromJson)
  double? get longitude;

  /// Create a copy of AppointmentShop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentShopImplCopyWith<_$AppointmentShopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppointmentBookingRequest _$AppointmentBookingRequestFromJson(
  Map<String, dynamic> json,
) {
  return _AppointmentBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$AppointmentBookingRequest {
  // ignore: invalid_annotation_target
  @JsonKey(name: 'shop_id')
  int get shopId => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'barber_id')
  int get barberId => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'service_id')
  int get serviceId => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  /// Serializes this AppointmentBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentBookingRequestCopyWith<AppointmentBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentBookingRequestCopyWith<$Res> {
  factory $AppointmentBookingRequestCopyWith(
    AppointmentBookingRequest value,
    $Res Function(AppointmentBookingRequest) then,
  ) = _$AppointmentBookingRequestCopyWithImpl<$Res, AppointmentBookingRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'shop_id') int shopId,
    @JsonKey(name: 'barber_id') int barberId,
    @JsonKey(name: 'service_id') int serviceId,
    String date,
    String time,
    String notes,
  });
}

/// @nodoc
class _$AppointmentBookingRequestCopyWithImpl<
  $Res,
  $Val extends AppointmentBookingRequest
>
    implements $AppointmentBookingRequestCopyWith<$Res> {
  _$AppointmentBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopId = null,
    Object? barberId = null,
    Object? serviceId = null,
    Object? date = null,
    Object? time = null,
    Object? notes = null,
  }) {
    return _then(
      _value.copyWith(
            shopId: null == shopId
                ? _value.shopId
                : shopId // ignore: cast_nullable_to_non_nullable
                      as int,
            barberId: null == barberId
                ? _value.barberId
                : barberId // ignore: cast_nullable_to_non_nullable
                      as int,
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppointmentBookingRequestImplCopyWith<$Res>
    implements $AppointmentBookingRequestCopyWith<$Res> {
  factory _$$AppointmentBookingRequestImplCopyWith(
    _$AppointmentBookingRequestImpl value,
    $Res Function(_$AppointmentBookingRequestImpl) then,
  ) = __$$AppointmentBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'shop_id') int shopId,
    @JsonKey(name: 'barber_id') int barberId,
    @JsonKey(name: 'service_id') int serviceId,
    String date,
    String time,
    String notes,
  });
}

/// @nodoc
class __$$AppointmentBookingRequestImplCopyWithImpl<$Res>
    extends
        _$AppointmentBookingRequestCopyWithImpl<
          $Res,
          _$AppointmentBookingRequestImpl
        >
    implements _$$AppointmentBookingRequestImplCopyWith<$Res> {
  __$$AppointmentBookingRequestImplCopyWithImpl(
    _$AppointmentBookingRequestImpl _value,
    $Res Function(_$AppointmentBookingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppointmentBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopId = null,
    Object? barberId = null,
    Object? serviceId = null,
    Object? date = null,
    Object? time = null,
    Object? notes = null,
  }) {
    return _then(
      _$AppointmentBookingRequestImpl(
        shopId: null == shopId
            ? _value.shopId
            : shopId // ignore: cast_nullable_to_non_nullable
                  as int,
        barberId: null == barberId
            ? _value.barberId
            : barberId // ignore: cast_nullable_to_non_nullable
                  as int,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentBookingRequestImpl implements _AppointmentBookingRequest {
  const _$AppointmentBookingRequestImpl({
    @JsonKey(name: 'shop_id') required this.shopId,
    @JsonKey(name: 'barber_id') required this.barberId,
    @JsonKey(name: 'service_id') required this.serviceId,
    required this.date,
    required this.time,
    this.notes = '',
  });

  factory _$AppointmentBookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentBookingRequestImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'shop_id')
  final int shopId;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'barber_id')
  final int barberId;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'service_id')
  final int serviceId;
  @override
  final String date;
  @override
  final String time;
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'AppointmentBookingRequest(shopId: $shopId, barberId: $barberId, serviceId: $serviceId, date: $date, time: $time, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentBookingRequestImpl &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.barberId, barberId) ||
                other.barberId == barberId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, shopId, barberId, serviceId, date, time, notes);

  /// Create a copy of AppointmentBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentBookingRequestImplCopyWith<_$AppointmentBookingRequestImpl>
  get copyWith =>
      __$$AppointmentBookingRequestImplCopyWithImpl<
        _$AppointmentBookingRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentBookingRequestImplToJson(this);
  }
}

abstract class _AppointmentBookingRequest implements AppointmentBookingRequest {
  const factory _AppointmentBookingRequest({
    @JsonKey(name: 'shop_id') required final int shopId,
    @JsonKey(name: 'barber_id') required final int barberId,
    @JsonKey(name: 'service_id') required final int serviceId,
    required final String date,
    required final String time,
    final String notes,
  }) = _$AppointmentBookingRequestImpl;

  factory _AppointmentBookingRequest.fromJson(Map<String, dynamic> json) =
      _$AppointmentBookingRequestImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'shop_id')
  int get shopId; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'barber_id')
  int get barberId; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'service_id')
  int get serviceId;
  @override
  String get date;
  @override
  String get time;
  @override
  String get notes;

  /// Create a copy of AppointmentBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentBookingRequestImplCopyWith<_$AppointmentBookingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RecurringRepeat _$RecurringRepeatFromJson(Map<String, dynamic> json) {
  return _RecurringRepeat.fromJson(json);
}

/// @nodoc
mixin _$RecurringRepeat {
  RecurringRepeatType get type => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;

  /// Serializes this RecurringRepeat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringRepeat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringRepeatCopyWith<RecurringRepeat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringRepeatCopyWith<$Res> {
  factory $RecurringRepeatCopyWith(
    RecurringRepeat value,
    $Res Function(RecurringRepeat) then,
  ) = _$RecurringRepeatCopyWithImpl<$Res, RecurringRepeat>;
  @useResult
  $Res call({RecurringRepeatType type, int value});
}

/// @nodoc
class _$RecurringRepeatCopyWithImpl<$Res, $Val extends RecurringRepeat>
    implements $RecurringRepeatCopyWith<$Res> {
  _$RecurringRepeatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringRepeat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RecurringRepeatType,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurringRepeatImplCopyWith<$Res>
    implements $RecurringRepeatCopyWith<$Res> {
  factory _$$RecurringRepeatImplCopyWith(
    _$RecurringRepeatImpl value,
    $Res Function(_$RecurringRepeatImpl) then,
  ) = __$$RecurringRepeatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RecurringRepeatType type, int value});
}

/// @nodoc
class __$$RecurringRepeatImplCopyWithImpl<$Res>
    extends _$RecurringRepeatCopyWithImpl<$Res, _$RecurringRepeatImpl>
    implements _$$RecurringRepeatImplCopyWith<$Res> {
  __$$RecurringRepeatImplCopyWithImpl(
    _$RecurringRepeatImpl _value,
    $Res Function(_$RecurringRepeatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringRepeat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? value = null}) {
    return _then(
      _$RecurringRepeatImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RecurringRepeatType,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringRepeatImpl implements _RecurringRepeat {
  const _$RecurringRepeatImpl({required this.type, required this.value});

  factory _$RecurringRepeatImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringRepeatImplFromJson(json);

  @override
  final RecurringRepeatType type;
  @override
  final int value;

  @override
  String toString() {
    return 'RecurringRepeat(type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringRepeatImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, value);

  /// Create a copy of RecurringRepeat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringRepeatImplCopyWith<_$RecurringRepeatImpl> get copyWith =>
      __$$RecurringRepeatImplCopyWithImpl<_$RecurringRepeatImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringRepeatImplToJson(this);
  }
}

abstract class _RecurringRepeat implements RecurringRepeat {
  const factory _RecurringRepeat({
    required final RecurringRepeatType type,
    required final int value,
  }) = _$RecurringRepeatImpl;

  factory _RecurringRepeat.fromJson(Map<String, dynamic> json) =
      _$RecurringRepeatImpl.fromJson;

  @override
  RecurringRepeatType get type;
  @override
  int get value;

  /// Create a copy of RecurringRepeat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringRepeatImplCopyWith<_$RecurringRepeatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurringAppointmentRequest _$RecurringAppointmentRequestFromJson(
  Map<String, dynamic> json,
) {
  return _RecurringAppointmentRequest.fromJson(json);
}

/// @nodoc
mixin _$RecurringAppointmentRequest {
  // ignore: invalid_annotation_target
  @JsonKey(name: 'shop_id')
  int get shopId => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'barber_id')
  int get barberId => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'service_id')
  int get serviceId => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  RecurringRepeat get repeat => throw _privateConstructorUsedError;

  /// Serializes this RecurringAppointmentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringAppointmentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringAppointmentRequestCopyWith<RecurringAppointmentRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringAppointmentRequestCopyWith<$Res> {
  factory $RecurringAppointmentRequestCopyWith(
    RecurringAppointmentRequest value,
    $Res Function(RecurringAppointmentRequest) then,
  ) =
      _$RecurringAppointmentRequestCopyWithImpl<
        $Res,
        RecurringAppointmentRequest
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'shop_id') int shopId,
    @JsonKey(name: 'barber_id') int barberId,
    @JsonKey(name: 'service_id') int serviceId,
    String date,
    String time,
    String? notes,
    RecurringRepeat repeat,
  });

  $RecurringRepeatCopyWith<$Res> get repeat;
}

/// @nodoc
class _$RecurringAppointmentRequestCopyWithImpl<
  $Res,
  $Val extends RecurringAppointmentRequest
>
    implements $RecurringAppointmentRequestCopyWith<$Res> {
  _$RecurringAppointmentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringAppointmentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopId = null,
    Object? barberId = null,
    Object? serviceId = null,
    Object? date = null,
    Object? time = null,
    Object? notes = freezed,
    Object? repeat = null,
  }) {
    return _then(
      _value.copyWith(
            shopId: null == shopId
                ? _value.shopId
                : shopId // ignore: cast_nullable_to_non_nullable
                      as int,
            barberId: null == barberId
                ? _value.barberId
                : barberId // ignore: cast_nullable_to_non_nullable
                      as int,
            serviceId: null == serviceId
                ? _value.serviceId
                : serviceId // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            repeat: null == repeat
                ? _value.repeat
                : repeat // ignore: cast_nullable_to_non_nullable
                      as RecurringRepeat,
          )
          as $Val,
    );
  }

  /// Create a copy of RecurringAppointmentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurringRepeatCopyWith<$Res> get repeat {
    return $RecurringRepeatCopyWith<$Res>(_value.repeat, (value) {
      return _then(_value.copyWith(repeat: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecurringAppointmentRequestImplCopyWith<$Res>
    implements $RecurringAppointmentRequestCopyWith<$Res> {
  factory _$$RecurringAppointmentRequestImplCopyWith(
    _$RecurringAppointmentRequestImpl value,
    $Res Function(_$RecurringAppointmentRequestImpl) then,
  ) = __$$RecurringAppointmentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'shop_id') int shopId,
    @JsonKey(name: 'barber_id') int barberId,
    @JsonKey(name: 'service_id') int serviceId,
    String date,
    String time,
    String? notes,
    RecurringRepeat repeat,
  });

  @override
  $RecurringRepeatCopyWith<$Res> get repeat;
}

/// @nodoc
class __$$RecurringAppointmentRequestImplCopyWithImpl<$Res>
    extends
        _$RecurringAppointmentRequestCopyWithImpl<
          $Res,
          _$RecurringAppointmentRequestImpl
        >
    implements _$$RecurringAppointmentRequestImplCopyWith<$Res> {
  __$$RecurringAppointmentRequestImplCopyWithImpl(
    _$RecurringAppointmentRequestImpl _value,
    $Res Function(_$RecurringAppointmentRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringAppointmentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopId = null,
    Object? barberId = null,
    Object? serviceId = null,
    Object? date = null,
    Object? time = null,
    Object? notes = freezed,
    Object? repeat = null,
  }) {
    return _then(
      _$RecurringAppointmentRequestImpl(
        shopId: null == shopId
            ? _value.shopId
            : shopId // ignore: cast_nullable_to_non_nullable
                  as int,
        barberId: null == barberId
            ? _value.barberId
            : barberId // ignore: cast_nullable_to_non_nullable
                  as int,
        serviceId: null == serviceId
            ? _value.serviceId
            : serviceId // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        repeat: null == repeat
            ? _value.repeat
            : repeat // ignore: cast_nullable_to_non_nullable
                  as RecurringRepeat,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringAppointmentRequestImpl
    implements _RecurringAppointmentRequest {
  const _$RecurringAppointmentRequestImpl({
    @JsonKey(name: 'shop_id') required this.shopId,
    @JsonKey(name: 'barber_id') required this.barberId,
    @JsonKey(name: 'service_id') required this.serviceId,
    required this.date,
    required this.time,
    this.notes,
    required this.repeat,
  });

  factory _$RecurringAppointmentRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$RecurringAppointmentRequestImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'shop_id')
  final int shopId;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'barber_id')
  final int barberId;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'service_id')
  final int serviceId;
  @override
  final String date;
  @override
  final String time;
  @override
  final String? notes;
  @override
  final RecurringRepeat repeat;

  @override
  String toString() {
    return 'RecurringAppointmentRequest(shopId: $shopId, barberId: $barberId, serviceId: $serviceId, date: $date, time: $time, notes: $notes, repeat: $repeat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringAppointmentRequestImpl &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.barberId, barberId) ||
                other.barberId == barberId) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.repeat, repeat) || other.repeat == repeat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    shopId,
    barberId,
    serviceId,
    date,
    time,
    notes,
    repeat,
  );

  /// Create a copy of RecurringAppointmentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringAppointmentRequestImplCopyWith<_$RecurringAppointmentRequestImpl>
  get copyWith =>
      __$$RecurringAppointmentRequestImplCopyWithImpl<
        _$RecurringAppointmentRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringAppointmentRequestImplToJson(this);
  }
}

abstract class _RecurringAppointmentRequest
    implements RecurringAppointmentRequest {
  const factory _RecurringAppointmentRequest({
    @JsonKey(name: 'shop_id') required final int shopId,
    @JsonKey(name: 'barber_id') required final int barberId,
    @JsonKey(name: 'service_id') required final int serviceId,
    required final String date,
    required final String time,
    final String? notes,
    required final RecurringRepeat repeat,
  }) = _$RecurringAppointmentRequestImpl;

  factory _RecurringAppointmentRequest.fromJson(Map<String, dynamic> json) =
      _$RecurringAppointmentRequestImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'shop_id')
  int get shopId; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'barber_id')
  int get barberId; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'service_id')
  int get serviceId;
  @override
  String get date;
  @override
  String get time;
  @override
  String? get notes;
  @override
  RecurringRepeat get repeat;

  /// Create a copy of RecurringAppointmentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringAppointmentRequestImplCopyWith<_$RecurringAppointmentRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RecurringSkippedSlot _$RecurringSkippedSlotFromJson(Map<String, dynamic> json) {
  return _RecurringSkippedSlot.fromJson(json);
}

/// @nodoc
mixin _$RecurringSkippedSlot {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime? get datetime => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this RecurringSkippedSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringSkippedSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringSkippedSlotCopyWith<RecurringSkippedSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringSkippedSlotCopyWith<$Res> {
  factory $RecurringSkippedSlotCopyWith(
    RecurringSkippedSlot value,
    $Res Function(RecurringSkippedSlot) then,
  ) = _$RecurringSkippedSlotCopyWithImpl<$Res, RecurringSkippedSlot>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _dateTimeFromJson) DateTime? datetime,
    String reason,
  });
}

/// @nodoc
class _$RecurringSkippedSlotCopyWithImpl<
  $Res,
  $Val extends RecurringSkippedSlot
>
    implements $RecurringSkippedSlotCopyWith<$Res> {
  _$RecurringSkippedSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringSkippedSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? datetime = freezed, Object? reason = null}) {
    return _then(
      _value.copyWith(
            datetime: freezed == datetime
                ? _value.datetime
                : datetime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurringSkippedSlotImplCopyWith<$Res>
    implements $RecurringSkippedSlotCopyWith<$Res> {
  factory _$$RecurringSkippedSlotImplCopyWith(
    _$RecurringSkippedSlotImpl value,
    $Res Function(_$RecurringSkippedSlotImpl) then,
  ) = __$$RecurringSkippedSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _dateTimeFromJson) DateTime? datetime,
    String reason,
  });
}

/// @nodoc
class __$$RecurringSkippedSlotImplCopyWithImpl<$Res>
    extends _$RecurringSkippedSlotCopyWithImpl<$Res, _$RecurringSkippedSlotImpl>
    implements _$$RecurringSkippedSlotImplCopyWith<$Res> {
  __$$RecurringSkippedSlotImplCopyWithImpl(
    _$RecurringSkippedSlotImpl _value,
    $Res Function(_$RecurringSkippedSlotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringSkippedSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? datetime = freezed, Object? reason = null}) {
    return _then(
      _$RecurringSkippedSlotImpl(
        datetime: freezed == datetime
            ? _value.datetime
            : datetime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringSkippedSlotImpl implements _RecurringSkippedSlot {
  const _$RecurringSkippedSlotImpl({
    @JsonKey(fromJson: _dateTimeFromJson) this.datetime,
    this.reason = '',
  });

  factory _$RecurringSkippedSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringSkippedSlotImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  final DateTime? datetime;
  @override
  @JsonKey()
  final String reason;

  @override
  String toString() {
    return 'RecurringSkippedSlot(datetime: $datetime, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringSkippedSlotImpl &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, datetime, reason);

  /// Create a copy of RecurringSkippedSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringSkippedSlotImplCopyWith<_$RecurringSkippedSlotImpl>
  get copyWith =>
      __$$RecurringSkippedSlotImplCopyWithImpl<_$RecurringSkippedSlotImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringSkippedSlotImplToJson(this);
  }
}

abstract class _RecurringSkippedSlot implements RecurringSkippedSlot {
  const factory _RecurringSkippedSlot({
    @JsonKey(fromJson: _dateTimeFromJson) final DateTime? datetime,
    final String reason,
  }) = _$RecurringSkippedSlotImpl;

  factory _RecurringSkippedSlot.fromJson(Map<String, dynamic> json) =
      _$RecurringSkippedSlotImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime? get datetime;
  @override
  String get reason;

  /// Create a copy of RecurringSkippedSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringSkippedSlotImplCopyWith<_$RecurringSkippedSlotImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RecurringAppointmentResult _$RecurringAppointmentResultFromJson(
  Map<String, dynamic> json,
) {
  return _RecurringAppointmentResult.fromJson(json);
}

/// @nodoc
mixin _$RecurringAppointmentResult {
  List<AppointmentModel> get booked => throw _privateConstructorUsedError;
  List<RecurringSkippedSlot> get skipped =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'recurring_group_id')
  String? get recurringGroupId => throw _privateConstructorUsedError;

  /// Serializes this RecurringAppointmentResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringAppointmentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringAppointmentResultCopyWith<RecurringAppointmentResult>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringAppointmentResultCopyWith<$Res> {
  factory $RecurringAppointmentResultCopyWith(
    RecurringAppointmentResult value,
    $Res Function(RecurringAppointmentResult) then,
  ) =
      _$RecurringAppointmentResultCopyWithImpl<
        $Res,
        RecurringAppointmentResult
      >;
  @useResult
  $Res call({
    List<AppointmentModel> booked,
    List<RecurringSkippedSlot> skipped,
    @JsonKey(name: 'recurring_group_id') String? recurringGroupId,
  });
}

/// @nodoc
class _$RecurringAppointmentResultCopyWithImpl<
  $Res,
  $Val extends RecurringAppointmentResult
>
    implements $RecurringAppointmentResultCopyWith<$Res> {
  _$RecurringAppointmentResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringAppointmentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booked = null,
    Object? skipped = null,
    Object? recurringGroupId = freezed,
  }) {
    return _then(
      _value.copyWith(
            booked: null == booked
                ? _value.booked
                : booked // ignore: cast_nullable_to_non_nullable
                      as List<AppointmentModel>,
            skipped: null == skipped
                ? _value.skipped
                : skipped // ignore: cast_nullable_to_non_nullable
                      as List<RecurringSkippedSlot>,
            recurringGroupId: freezed == recurringGroupId
                ? _value.recurringGroupId
                : recurringGroupId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurringAppointmentResultImplCopyWith<$Res>
    implements $RecurringAppointmentResultCopyWith<$Res> {
  factory _$$RecurringAppointmentResultImplCopyWith(
    _$RecurringAppointmentResultImpl value,
    $Res Function(_$RecurringAppointmentResultImpl) then,
  ) = __$$RecurringAppointmentResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<AppointmentModel> booked,
    List<RecurringSkippedSlot> skipped,
    @JsonKey(name: 'recurring_group_id') String? recurringGroupId,
  });
}

/// @nodoc
class __$$RecurringAppointmentResultImplCopyWithImpl<$Res>
    extends
        _$RecurringAppointmentResultCopyWithImpl<
          $Res,
          _$RecurringAppointmentResultImpl
        >
    implements _$$RecurringAppointmentResultImplCopyWith<$Res> {
  __$$RecurringAppointmentResultImplCopyWithImpl(
    _$RecurringAppointmentResultImpl _value,
    $Res Function(_$RecurringAppointmentResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringAppointmentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booked = null,
    Object? skipped = null,
    Object? recurringGroupId = freezed,
  }) {
    return _then(
      _$RecurringAppointmentResultImpl(
        booked: null == booked
            ? _value._booked
            : booked // ignore: cast_nullable_to_non_nullable
                  as List<AppointmentModel>,
        skipped: null == skipped
            ? _value._skipped
            : skipped // ignore: cast_nullable_to_non_nullable
                  as List<RecurringSkippedSlot>,
        recurringGroupId: freezed == recurringGroupId
            ? _value.recurringGroupId
            : recurringGroupId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringAppointmentResultImpl implements _RecurringAppointmentResult {
  const _$RecurringAppointmentResultImpl({
    final List<AppointmentModel> booked = const <AppointmentModel>[],
    final List<RecurringSkippedSlot> skipped = const <RecurringSkippedSlot>[],
    @JsonKey(name: 'recurring_group_id') this.recurringGroupId,
  }) : _booked = booked,
       _skipped = skipped;

  factory _$RecurringAppointmentResultImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$RecurringAppointmentResultImplFromJson(json);

  final List<AppointmentModel> _booked;
  @override
  @JsonKey()
  List<AppointmentModel> get booked {
    if (_booked is EqualUnmodifiableListView) return _booked;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_booked);
  }

  final List<RecurringSkippedSlot> _skipped;
  @override
  @JsonKey()
  List<RecurringSkippedSlot> get skipped {
    if (_skipped is EqualUnmodifiableListView) return _skipped;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skipped);
  }

  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'recurring_group_id')
  final String? recurringGroupId;

  @override
  String toString() {
    return 'RecurringAppointmentResult(booked: $booked, skipped: $skipped, recurringGroupId: $recurringGroupId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringAppointmentResultImpl &&
            const DeepCollectionEquality().equals(other._booked, _booked) &&
            const DeepCollectionEquality().equals(other._skipped, _skipped) &&
            (identical(other.recurringGroupId, recurringGroupId) ||
                other.recurringGroupId == recurringGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_booked),
    const DeepCollectionEquality().hash(_skipped),
    recurringGroupId,
  );

  /// Create a copy of RecurringAppointmentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringAppointmentResultImplCopyWith<_$RecurringAppointmentResultImpl>
  get copyWith =>
      __$$RecurringAppointmentResultImplCopyWithImpl<
        _$RecurringAppointmentResultImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringAppointmentResultImplToJson(this);
  }
}

abstract class _RecurringAppointmentResult
    implements RecurringAppointmentResult {
  const factory _RecurringAppointmentResult({
    final List<AppointmentModel> booked,
    final List<RecurringSkippedSlot> skipped,
    @JsonKey(name: 'recurring_group_id') final String? recurringGroupId,
  }) = _$RecurringAppointmentResultImpl;

  factory _RecurringAppointmentResult.fromJson(Map<String, dynamic> json) =
      _$RecurringAppointmentResultImpl.fromJson;

  @override
  List<AppointmentModel> get booked;
  @override
  List<RecurringSkippedSlot> get skipped; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'recurring_group_id')
  String? get recurringGroupId;

  /// Create a copy of RecurringAppointmentResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringAppointmentResultImplCopyWith<_$RecurringAppointmentResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
