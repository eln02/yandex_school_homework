// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_brief_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AccountBriefDto _$AccountBriefDtoFromJson(Map<String, dynamic> json) {
  return _AccountBriefDto.fromJson(json);
}

/// @nodoc
mixin _$AccountBriefDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this AccountBriefDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountBriefDtoCopyWith<AccountBriefDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountBriefDtoCopyWith<$Res> {
  factory $AccountBriefDtoCopyWith(
    AccountBriefDto value,
    $Res Function(AccountBriefDto) then,
  ) = _$AccountBriefDtoCopyWithImpl<$Res, AccountBriefDto>;
  @useResult
  $Res call({int id, String name, String balance, String currency});
}

/// @nodoc
class _$AccountBriefDtoCopyWithImpl<$Res, $Val extends AccountBriefDto>
    implements $AccountBriefDtoCopyWith<$Res> {
  _$AccountBriefDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? balance = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountBriefDtoImplCopyWith<$Res>
    implements $AccountBriefDtoCopyWith<$Res> {
  factory _$$AccountBriefDtoImplCopyWith(
    _$AccountBriefDtoImpl value,
    $Res Function(_$AccountBriefDtoImpl) then,
  ) = __$$AccountBriefDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String balance, String currency});
}

/// @nodoc
class __$$AccountBriefDtoImplCopyWithImpl<$Res>
    extends _$AccountBriefDtoCopyWithImpl<$Res, _$AccountBriefDtoImpl>
    implements _$$AccountBriefDtoImplCopyWith<$Res> {
  __$$AccountBriefDtoImplCopyWithImpl(
    _$AccountBriefDtoImpl _value,
    $Res Function(_$AccountBriefDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? balance = null,
    Object? currency = null,
  }) {
    return _then(
      _$AccountBriefDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountBriefDtoImpl implements _AccountBriefDto {
  const _$AccountBriefDtoImpl({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });

  factory _$AccountBriefDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountBriefDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String balance;
  @override
  final String currency;

  @override
  String toString() {
    return 'AccountBriefDto(id: $id, name: $name, balance: $balance, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountBriefDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, balance, currency);

  /// Create a copy of AccountBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountBriefDtoImplCopyWith<_$AccountBriefDtoImpl> get copyWith =>
      __$$AccountBriefDtoImplCopyWithImpl<_$AccountBriefDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountBriefDtoImplToJson(this);
  }
}

abstract class _AccountBriefDto implements AccountBriefDto {
  const factory _AccountBriefDto({
    required final int id,
    required final String name,
    required final String balance,
    required final String currency,
  }) = _$AccountBriefDtoImpl;

  factory _AccountBriefDto.fromJson(Map<String, dynamic> json) =
      _$AccountBriefDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get balance;
  @override
  String get currency;

  /// Create a copy of AccountBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountBriefDtoImplCopyWith<_$AccountBriefDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
