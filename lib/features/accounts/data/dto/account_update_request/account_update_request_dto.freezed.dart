// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_update_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AccountUpdateRequestDto _$AccountUpdateRequestDtoFromJson(
  Map<String, dynamic> json,
) {
  return _AccountUpdateRequestDto.fromJson(json);
}

/// @nodoc
mixin _$AccountUpdateRequestDto {
  String get name => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this AccountUpdateRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountUpdateRequestDtoCopyWith<AccountUpdateRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountUpdateRequestDtoCopyWith<$Res> {
  factory $AccountUpdateRequestDtoCopyWith(
    AccountUpdateRequestDto value,
    $Res Function(AccountUpdateRequestDto) then,
  ) = _$AccountUpdateRequestDtoCopyWithImpl<$Res, AccountUpdateRequestDto>;
  @useResult
  $Res call({String name, String balance, String currency});
}

/// @nodoc
class _$AccountUpdateRequestDtoCopyWithImpl<
  $Res,
  $Val extends AccountUpdateRequestDto
>
    implements $AccountUpdateRequestDtoCopyWith<$Res> {
  _$AccountUpdateRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? balance = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
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
abstract class _$$AccountUpdateRequestDtoImplCopyWith<$Res>
    implements $AccountUpdateRequestDtoCopyWith<$Res> {
  factory _$$AccountUpdateRequestDtoImplCopyWith(
    _$AccountUpdateRequestDtoImpl value,
    $Res Function(_$AccountUpdateRequestDtoImpl) then,
  ) = __$$AccountUpdateRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String balance, String currency});
}

/// @nodoc
class __$$AccountUpdateRequestDtoImplCopyWithImpl<$Res>
    extends
        _$AccountUpdateRequestDtoCopyWithImpl<
          $Res,
          _$AccountUpdateRequestDtoImpl
        >
    implements _$$AccountUpdateRequestDtoImplCopyWith<$Res> {
  __$$AccountUpdateRequestDtoImplCopyWithImpl(
    _$AccountUpdateRequestDtoImpl _value,
    $Res Function(_$AccountUpdateRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? balance = null,
    Object? currency = null,
  }) {
    return _then(
      _$AccountUpdateRequestDtoImpl(
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
class _$AccountUpdateRequestDtoImpl implements _AccountUpdateRequestDto {
  const _$AccountUpdateRequestDtoImpl({
    required this.name,
    required this.balance,
    required this.currency,
  });

  factory _$AccountUpdateRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountUpdateRequestDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String balance;
  @override
  final String currency;

  @override
  String toString() {
    return 'AccountUpdateRequestDto(name: $name, balance: $balance, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountUpdateRequestDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, balance, currency);

  /// Create a copy of AccountUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountUpdateRequestDtoImplCopyWith<_$AccountUpdateRequestDtoImpl>
  get copyWith =>
      __$$AccountUpdateRequestDtoImplCopyWithImpl<
        _$AccountUpdateRequestDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountUpdateRequestDtoImplToJson(this);
  }
}

abstract class _AccountUpdateRequestDto implements AccountUpdateRequestDto {
  const factory _AccountUpdateRequestDto({
    required final String name,
    required final String balance,
    required final String currency,
  }) = _$AccountUpdateRequestDtoImpl;

  factory _AccountUpdateRequestDto.fromJson(Map<String, dynamic> json) =
      _$AccountUpdateRequestDtoImpl.fromJson;

  @override
  String get name;
  @override
  String get balance;
  @override
  String get currency;

  /// Create a copy of AccountUpdateRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountUpdateRequestDtoImplCopyWith<_$AccountUpdateRequestDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
