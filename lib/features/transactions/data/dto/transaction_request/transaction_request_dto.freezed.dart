// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionRequestDto _$TransactionRequestDtoFromJson(
  Map<String, dynamic> json,
) {
  return _TransactionRequestDto.fromJson(json);
}

/// @nodoc
mixin _$TransactionRequestDto {
  int get accountId => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get transactionDate => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  /// Serializes this TransactionRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionRequestDtoCopyWith<TransactionRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionRequestDtoCopyWith<$Res> {
  factory $TransactionRequestDtoCopyWith(
    TransactionRequestDto value,
    $Res Function(TransactionRequestDto) then,
  ) = _$TransactionRequestDtoCopyWithImpl<$Res, TransactionRequestDto>;
  @useResult
  $Res call({
    int accountId,
    int categoryId,
    String amount,
    String transactionDate,
    String? comment,
  });
}

/// @nodoc
class _$TransactionRequestDtoCopyWithImpl<
  $Res,
  $Val extends TransactionRequestDto
>
    implements $TransactionRequestDtoCopyWith<$Res> {
  _$TransactionRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? categoryId = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? comment = freezed,
  }) {
    return _then(
      _value.copyWith(
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as String,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionRequestDtoImplCopyWith<$Res>
    implements $TransactionRequestDtoCopyWith<$Res> {
  factory _$$TransactionRequestDtoImplCopyWith(
    _$TransactionRequestDtoImpl value,
    $Res Function(_$TransactionRequestDtoImpl) then,
  ) = __$$TransactionRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int accountId,
    int categoryId,
    String amount,
    String transactionDate,
    String? comment,
  });
}

/// @nodoc
class __$$TransactionRequestDtoImplCopyWithImpl<$Res>
    extends
        _$TransactionRequestDtoCopyWithImpl<$Res, _$TransactionRequestDtoImpl>
    implements _$$TransactionRequestDtoImplCopyWith<$Res> {
  __$$TransactionRequestDtoImplCopyWithImpl(
    _$TransactionRequestDtoImpl _value,
    $Res Function(_$TransactionRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? categoryId = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? comment = freezed,
  }) {
    return _then(
      _$TransactionRequestDtoImpl(
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as String,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionRequestDtoImpl implements _TransactionRequestDto {
  const _$TransactionRequestDtoImpl({
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.transactionDate,
    this.comment,
  });

  factory _$TransactionRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionRequestDtoImplFromJson(json);

  @override
  final int accountId;
  @override
  final int categoryId;
  @override
  final String amount;
  @override
  final String transactionDate;
  @override
  final String? comment;

  @override
  String toString() {
    return 'TransactionRequestDto(accountId: $accountId, categoryId: $categoryId, amount: $amount, transactionDate: $transactionDate, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionRequestDtoImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accountId,
    categoryId,
    amount,
    transactionDate,
    comment,
  );

  /// Create a copy of TransactionRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionRequestDtoImplCopyWith<_$TransactionRequestDtoImpl>
  get copyWith =>
      __$$TransactionRequestDtoImplCopyWithImpl<_$TransactionRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionRequestDtoImplToJson(this);
  }
}

abstract class _TransactionRequestDto implements TransactionRequestDto {
  const factory _TransactionRequestDto({
    required final int accountId,
    required final int categoryId,
    required final String amount,
    required final String transactionDate,
    final String? comment,
  }) = _$TransactionRequestDtoImpl;

  factory _TransactionRequestDto.fromJson(Map<String, dynamic> json) =
      _$TransactionRequestDtoImpl.fromJson;

  @override
  int get accountId;
  @override
  int get categoryId;
  @override
  String get amount;
  @override
  String get transactionDate;
  @override
  String? get comment;

  /// Create a copy of TransactionRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionRequestDtoImplCopyWith<_$TransactionRequestDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
