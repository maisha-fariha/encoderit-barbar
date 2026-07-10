// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return _Shop.fromJson(json);
}

/// @nodoc
mixin _$Shop {
  // ignore: invalid_annotation_target
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get email =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson)
  double? get latitude => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
  double? get longitude => throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// IANA timezone for this shop (e.g. `Europe/Rome`). Fallback: UTC.
  String get timezone => throw _privateConstructorUsedError;
  List<ShopService> get services => throw _privateConstructorUsedError;

  /// Serializes this Shop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopCopyWith<Shop> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopCopyWith<$Res> {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) then) =
      _$ShopCopyWithImpl<$Res, Shop>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String address,
    String phone,
    String email,
    @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson)
    double? latitude,
    @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
    double? longitude,
    @JsonKey(name: 'is_active') bool isActive,
    String timezone,
    List<ShopService> services,
  });
}

/// @nodoc
class _$ShopCopyWithImpl<$Res, $Val extends Shop>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? email = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isActive = null,
    Object? timezone = null,
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
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            timezone: null == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String,
            services: null == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<ShopService>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShopImplCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$$ShopImplCopyWith(
    _$ShopImpl value,
    $Res Function(_$ShopImpl) then,
  ) = __$$ShopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String name,
    String address,
    String phone,
    String email,
    @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson)
    double? latitude,
    @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
    double? longitude,
    @JsonKey(name: 'is_active') bool isActive,
    String timezone,
    List<ShopService> services,
  });
}

/// @nodoc
class __$$ShopImplCopyWithImpl<$Res>
    extends _$ShopCopyWithImpl<$Res, _$ShopImpl>
    implements _$$ShopImplCopyWith<$Res> {
  __$$ShopImplCopyWithImpl(_$ShopImpl _value, $Res Function(_$ShopImpl) _then)
    : super(_value, _then);

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? email = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? isActive = null,
    Object? timezone = null,
    Object? services = null,
  }) {
    return _then(
      _$ShopImpl(
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
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        timezone: null == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        services: null == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<ShopService>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopImpl implements _Shop {
  const _$ShopImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    this.name = '',
    this.address = '',
    this.phone = '',
    this.email = '',
    @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson) this.latitude,
    @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
    this.longitude,
    @JsonKey(name: 'is_active') this.isActive = false,
    this.timezone = 'UTC',
    final List<ShopService> services = const <ShopService>[],
  }) : _services = services;

  factory _$ShopImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopImplFromJson(json);

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
  @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson)
  final double? latitude;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
  final double? longitude;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// IANA timezone for this shop (e.g. `Europe/Rome`). Fallback: UTC.
  @override
  @JsonKey()
  final String timezone;
  final List<ShopService> _services;
  @override
  @JsonKey()
  List<ShopService> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  String toString() {
    return 'Shop(id: $id, name: $name, address: $address, phone: $phone, email: $email, latitude: $latitude, longitude: $longitude, isActive: $isActive, timezone: $timezone, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            const DeepCollectionEquality().equals(other._services, _services));
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
    latitude,
    longitude,
    isActive,
    timezone,
    const DeepCollectionEquality().hash(_services),
  );

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopImplCopyWith<_$ShopImpl> get copyWith =>
      __$$ShopImplCopyWithImpl<_$ShopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopImplToJson(this);
  }
}

abstract class _Shop implements Shop {
  const factory _Shop({
    @JsonKey(fromJson: _idFromJson) required final String id,
    final String name,
    final String address,
    final String phone,
    final String email,
    @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson)
    final double? latitude,
    @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
    final double? longitude,
    @JsonKey(name: 'is_active') final bool isActive,
    final String timezone,
    final List<ShopService> services,
  }) = _$ShopImpl;

  factory _Shop.fromJson(Map<String, dynamic> json) = _$ShopImpl.fromJson;

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
  @JsonKey(name: 'latitude', fromJson: _nullableDoubleFromJson)
  double? get latitude; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'longitude', fromJson: _nullableDoubleFromJson)
  double? get longitude; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// IANA timezone for this shop (e.g. `Europe/Rome`). Fallback: UTC.
  @override
  String get timezone;
  @override
  List<ShopService> get services;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopImplCopyWith<_$ShopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShopService _$ShopServiceFromJson(Map<String, dynamic> json) {
  return _ShopService.fromJson(json);
}

/// @nodoc
mixin _$ShopService {
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

  /// Serializes this ShopService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShopService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopServiceCopyWith<ShopService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopServiceCopyWith<$Res> {
  factory $ShopServiceCopyWith(
    ShopService value,
    $Res Function(ShopService) then,
  ) = _$ShopServiceCopyWithImpl<$Res, ShopService>;
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
class _$ShopServiceCopyWithImpl<$Res, $Val extends ShopService>
    implements $ShopServiceCopyWith<$Res> {
  _$ShopServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShopService
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
abstract class _$$ShopServiceImplCopyWith<$Res>
    implements $ShopServiceCopyWith<$Res> {
  factory _$$ShopServiceImplCopyWith(
    _$ShopServiceImpl value,
    $Res Function(_$ShopServiceImpl) then,
  ) = __$$ShopServiceImplCopyWithImpl<$Res>;
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
class __$$ShopServiceImplCopyWithImpl<$Res>
    extends _$ShopServiceCopyWithImpl<$Res, _$ShopServiceImpl>
    implements _$$ShopServiceImplCopyWith<$Res> {
  __$$ShopServiceImplCopyWithImpl(
    _$ShopServiceImpl _value,
    $Res Function(_$ShopServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShopService
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
      _$ShopServiceImpl(
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
class _$ShopServiceImpl implements _ShopService {
  const _$ShopServiceImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    this.name = '',
    this.description,
    @JsonKey(fromJson: _priceFromJson) this.price = 0,
    @JsonKey(name: 'duration_minutes') this.durationMinutes = 0,
    @JsonKey(name: 'is_active') this.isActive = false,
  });

  factory _$ShopServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopServiceImplFromJson(json);

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
    return 'ShopService(id: $id, name: $name, description: $description, price: $price, durationMinutes: $durationMinutes, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopServiceImpl &&
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

  /// Create a copy of ShopService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopServiceImplCopyWith<_$ShopServiceImpl> get copyWith =>
      __$$ShopServiceImplCopyWithImpl<_$ShopServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopServiceImplToJson(this);
  }
}

abstract class _ShopService implements ShopService {
  const factory _ShopService({
    @JsonKey(fromJson: _idFromJson) required final String id,
    final String name,
    final String? description,
    @JsonKey(fromJson: _priceFromJson) final double price,
    @JsonKey(name: 'duration_minutes') final int durationMinutes,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$ShopServiceImpl;

  factory _ShopService.fromJson(Map<String, dynamic> json) =
      _$ShopServiceImpl.fromJson;

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

  /// Create a copy of ShopService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopServiceImplCopyWith<_$ShopServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
