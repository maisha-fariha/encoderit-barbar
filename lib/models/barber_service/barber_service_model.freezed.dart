// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barber_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BarberService _$BarberServiceFromJson(Map<String, dynamic> json) {
  return _BarberService.fromJson(json);
}

/// @nodoc
mixin _$BarberService {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'pantone_value')
  String get pantoneValue => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'year')
  int get year => throw _privateConstructorUsedError;

  /// Serializes this BarberService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BarberService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarberServiceCopyWith<BarberService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarberServiceCopyWith<$Res> {
  factory $BarberServiceCopyWith(
    BarberService value,
    $Res Function(BarberService) then,
  ) = _$BarberServiceCopyWithImpl<$Res, BarberService>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String color,
    @JsonKey(name: 'pantone_value') String pantoneValue,
    @JsonKey(name: 'year') int year,
  });
}

/// @nodoc
class _$BarberServiceCopyWithImpl<$Res, $Val extends BarberService>
    implements $BarberServiceCopyWith<$Res> {
  _$BarberServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BarberService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? pantoneValue = null,
    Object? year = null,
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
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            pantoneValue: null == pantoneValue
                ? _value.pantoneValue
                : pantoneValue // ignore: cast_nullable_to_non_nullable
                      as String,
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BarberServiceImplCopyWith<$Res>
    implements $BarberServiceCopyWith<$Res> {
  factory _$$BarberServiceImplCopyWith(
    _$BarberServiceImpl value,
    $Res Function(_$BarberServiceImpl) then,
  ) = __$$BarberServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String color,
    @JsonKey(name: 'pantone_value') String pantoneValue,
    @JsonKey(name: 'year') int year,
  });
}

/// @nodoc
class __$$BarberServiceImplCopyWithImpl<$Res>
    extends _$BarberServiceCopyWithImpl<$Res, _$BarberServiceImpl>
    implements _$$BarberServiceImplCopyWith<$Res> {
  __$$BarberServiceImplCopyWithImpl(
    _$BarberServiceImpl _value,
    $Res Function(_$BarberServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BarberService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? pantoneValue = null,
    Object? year = null,
  }) {
    return _then(
      _$BarberServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        pantoneValue: null == pantoneValue
            ? _value.pantoneValue
            : pantoneValue // ignore: cast_nullable_to_non_nullable
                  as String,
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BarberServiceImpl implements _BarberService {
  const _$BarberServiceImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    this.name = '',
    this.color = '',
    @JsonKey(name: 'pantone_value') this.pantoneValue = '',
    @JsonKey(name: 'year') this.year = 0,
  });

  factory _$BarberServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarberServiceImplFromJson(json);

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String color;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'pantone_value')
  final String pantoneValue;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'year')
  final int year;

  @override
  String toString() {
    return 'BarberService(id: $id, name: $name, color: $color, pantoneValue: $pantoneValue, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarberServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.pantoneValue, pantoneValue) ||
                other.pantoneValue == pantoneValue) &&
            (identical(other.year, year) || other.year == year));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, color, pantoneValue, year);

  /// Create a copy of BarberService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarberServiceImplCopyWith<_$BarberServiceImpl> get copyWith =>
      __$$BarberServiceImplCopyWithImpl<_$BarberServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BarberServiceImplToJson(this);
  }
}

abstract class _BarberService implements BarberService {
  const factory _BarberService({
    @JsonKey(fromJson: _idFromJson) required final String id,
    final String name,
    final String color,
    @JsonKey(name: 'pantone_value') final String pantoneValue,
    @JsonKey(name: 'year') final int year,
  }) = _$BarberServiceImpl;

  factory _BarberService.fromJson(Map<String, dynamic> json) =
      _$BarberServiceImpl.fromJson;

  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  String get name;
  @override
  String get color; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'pantone_value')
  String get pantoneValue; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'year')
  int get year;

  /// Create a copy of BarberService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarberServiceImplCopyWith<_$BarberServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
