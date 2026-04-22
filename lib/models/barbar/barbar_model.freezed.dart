// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barbar_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Barbar _$BarbarFromJson(Map<String, dynamic> json) {
  return _Barbar.fromJson(json);
}

/// @nodoc
mixin _$Barbar {
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;

  /// Serializes this Barbar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Barbar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarbarCopyWith<Barbar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarbarCopyWith<$Res> {
  factory $BarbarCopyWith(Barbar value, $Res Function(Barbar) then) =
      _$BarbarCopyWithImpl<$Res, Barbar>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    @JsonKey(name: 'username') String username,
  });
}

/// @nodoc
class _$BarbarCopyWithImpl<$Res, $Val extends Barbar>
    implements $BarbarCopyWith<$Res> {
  _$BarbarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Barbar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? username = null}) {
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
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BarbarImplCopyWith<$Res> implements $BarbarCopyWith<$Res> {
  factory _$$BarbarImplCopyWith(
    _$BarbarImpl value,
    $Res Function(_$BarbarImpl) then,
  ) = __$$BarbarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    @JsonKey(name: 'username') String username,
  });
}

/// @nodoc
class __$$BarbarImplCopyWithImpl<$Res>
    extends _$BarbarCopyWithImpl<$Res, _$BarbarImpl>
    implements _$$BarbarImplCopyWith<$Res> {
  __$$BarbarImplCopyWithImpl(
    _$BarbarImpl _value,
    $Res Function(_$BarbarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Barbar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? username = null}) {
    return _then(
      _$BarbarImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BarbarImpl implements _Barbar {
  const _$BarbarImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    required this.name,
    @JsonKey(name: 'username') this.username = '',
  });

  factory _$BarbarImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarbarImplFromJson(json);

  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'username')
  final String username;

  @override
  String toString() {
    return 'Barbar(id: $id, name: $name, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarbarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, username);

  /// Create a copy of Barbar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarbarImplCopyWith<_$BarbarImpl> get copyWith =>
      __$$BarbarImplCopyWithImpl<_$BarbarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BarbarImplToJson(this);
  }
}

abstract class _Barbar implements Barbar {
  const factory _Barbar({
    @JsonKey(fromJson: _idFromJson) required final String id,
    required final String name,
    @JsonKey(name: 'username') final String username,
  }) = _$BarbarImpl;

  factory _Barbar.fromJson(Map<String, dynamic> json) = _$BarbarImpl.fromJson;

  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'username')
  String get username;

  /// Create a copy of Barbar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarbarImplCopyWith<_$BarbarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
