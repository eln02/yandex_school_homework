// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionResponseDto _$TransactionResponseDtoFromJson(
  Map<String, dynamic> json,
) {
  return _TransactionResponseDto.fromJson(json);
}

/// @nodoc
mixin _$TransactionResponseDto {
  int get id => throw _privateConstructorUsedError;
  AccountBriefDto get account => throw _privateConstructorUsedError;
  CategoryDto get category => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  DateTime get transactionDate => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionResponseDtoCopyWith<TransactionResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionResponseDtoCopyWith<$Res> {
  factory $TransactionResponseDtoCopyWith(
    TransactionResponseDto value,
    $Res Function(TransactionResponseDto) then,
  ) = _$TransactionResponseDtoCopyWithImpl<$Res, TransactionResponseDto>;
  @useResult
  $Res call({
    int id,
    AccountBriefDto account,
    CategoryDto category,
    String amount,
    DateTime transactionDate,
    String? comment,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $AccountBriefDtoCopyWith<$Res> get account;
  $CategoryDtoCopyWith<$Res> get category;
}

/// @nodoc
class _$TransactionResponseDtoCopyWithImpl<
  $Res,
  $Val extends TransactionResponseDto
>
    implements $TransactionResponseDtoCopyWith<$Res> {
  _$TransactionResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? account = null,
    Object? category = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? comment = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            account: null == account
                ? _value.account
                : account // ignore: cast_nullable_to_non_nullable
                      as AccountBriefDto,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as CategoryDto,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of TransactionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountBriefDtoCopyWith<$Res> get account {
    return $AccountBriefDtoCopyWith<$Res>(_value.account, (value) {
      return _then(_value.copyWith(account: value) as $Val);
    });
  }

  /// Create a copy of TransactionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryDtoCopyWith<$Res> get category {
    return $CategoryDtoCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionResponseDtoImplCopyWith<$Res>
    implements $TransactionResponseDtoCopyWith<$Res> {
  factory _$$TransactionResponseDtoImplCopyWith(
    _$TransactionResponseDtoImpl value,
    $Res Function(_$TransactionResponseDtoImpl) then,
  ) = __$$TransactionResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    AccountBriefDto account,
    CategoryDto category,
    String amount,
    DateTime transactionDate,
    String? comment,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $AccountBriefDtoCopyWith<$Res> get account;
  @override
  $CategoryDtoCopyWith<$Res> get category;
}

/// @nodoc
class __$$TransactionResponseDtoImplCopyWithImpl<$Res>
    extends
        _$TransactionResponseDtoCopyWithImpl<$Res, _$TransactionResponseDtoImpl>
    implements _$$TransactionResponseDtoImplCopyWith<$Res> {
  __$$TransactionResponseDtoImplCopyWithImpl(
    _$TransactionResponseDtoImpl _value,
    $Res Function(_$TransactionResponseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? account = null,
    Object? category = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? comment = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TransactionResponseDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        account: null == account
            ? _value.account
            : account // ignore: cast_nullable_to_non_nullable
                  as AccountBriefDto,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CategoryDto,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionResponseDtoImpl implements _TransactionResponseDto {
  const _$TransactionResponseDtoImpl({
    required this.id,
    required this.account,
    required this.category,
    required this.amount,
    required this.transactionDate,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$TransactionResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionResponseDtoImplFromJson(json);

  @override
  final int id;
  @override
  final AccountBriefDto account;
  @override
  final CategoryDto category;
  @override
  final String amount;
  @override
  final DateTime transactionDate;
  @override
  final String? comment;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TransactionResponseDto(id: $id, account: $account, category: $category, amount: $amount, transactionDate: $transactionDate, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionResponseDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.comment, comment) || other.comment == comment) &&
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
    account,
    category,
    amount,
    transactionDate,
    comment,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TransactionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionResponseDtoImplCopyWith<_$TransactionResponseDtoImpl>
  get copyWith =>
      __$$TransactionResponseDtoImplCopyWithImpl<_$TransactionResponseDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionResponseDtoImplToJson(this);
  }
}

abstract class _TransactionResponseDto implements TransactionResponseDto {
  const factory _TransactionResponseDto({
    required final int id,
    required final AccountBriefDto account,
    required final CategoryDto category,
    required final String amount,
    required final DateTime transactionDate,
    final String? comment,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TransactionResponseDtoImpl;

  factory _TransactionResponseDto.fromJson(Map<String, dynamic> json) =
      _$TransactionResponseDtoImpl.fromJson;

  @override
  int get id;
  @override
  AccountBriefDto get account;
  @override
  CategoryDto get category;
  @override
  String get amount;
  @override
  DateTime get transactionDate;
  @override
  String? get comment;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TransactionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionResponseDtoImplCopyWith<_$TransactionResponseDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
