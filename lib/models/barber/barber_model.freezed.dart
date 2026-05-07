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
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  List<ServiceModel> get services => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') bool isActive,
    List<ServiceModel> services,
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
    Object? avatarUrl = freezed,
    Object? isActive = null,
    Object? services = null,
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
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            services: null == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<ServiceModel>,
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
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') bool isActive,
    List<ServiceModel> services,
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
    Object? avatarUrl = freezed,
    Object? isActive = null,
    Object? services = null,
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
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<ServiceModel>,
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
    @JsonKey(name: 'avatar_url') this.avatarUrl,
    @JsonKey(name: 'is_active') this.isActive = false,
    final List<ServiceModel> services = const <ServiceModel>[],
  }) : _services = services;

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
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
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

  @override
  String toString() {
    return 'BarberModel(id: $id, name: $name, email: $email, phone: $phone, gender: $gender, avatar: $avatar, avatarUrl: $avatarUrl, isActive: $isActive, services: $services)';
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
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._services, _services));
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
    avatarUrl,
    isActive,
    const DeepCollectionEquality().hash(_services),
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
    @JsonKey(name: 'avatar_url') final String? avatarUrl,
    @JsonKey(name: 'is_active') final bool isActive,
    final List<ServiceModel> services,
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
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  List<ServiceModel> get services;

  /// Create a copy of BarberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarberModelImplCopyWith<_$BarberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
