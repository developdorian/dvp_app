// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StateEntity {
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StateEntityCopyWith<StateEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateEntityCopyWith<$Res> {
  factory $StateEntityCopyWith(
          StateEntity value, $Res Function(StateEntity) then) =
      _$StateEntityCopyWithImpl<$Res, StateEntity>;
  @useResult
  $Res call({String code, String name, String countryCode});
}

/// @nodoc
class _$StateEntityCopyWithImpl<$Res, $Val extends StateEntity>
    implements $StateEntityCopyWith<$Res> {
  _$StateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? countryCode = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StateEntityImplCopyWith<$Res>
    implements $StateEntityCopyWith<$Res> {
  factory _$$StateEntityImplCopyWith(
          _$StateEntityImpl value, $Res Function(_$StateEntityImpl) then) =
      __$$StateEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String name, String countryCode});
}

/// @nodoc
class __$$StateEntityImplCopyWithImpl<$Res>
    extends _$StateEntityCopyWithImpl<$Res, _$StateEntityImpl>
    implements _$$StateEntityImplCopyWith<$Res> {
  __$$StateEntityImplCopyWithImpl(
      _$StateEntityImpl _value, $Res Function(_$StateEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? countryCode = null,
  }) {
    return _then(_$StateEntityImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StateEntityImpl implements _StateEntity {
  const _$StateEntityImpl(
      {required this.code, required this.name, required this.countryCode});

  @override
  final String code;
  @override
  final String name;
  @override
  final String countryCode;

  @override
  String toString() {
    return 'StateEntity(code: $code, name: $name, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateEntityImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, name, countryCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StateEntityImplCopyWith<_$StateEntityImpl> get copyWith =>
      __$$StateEntityImplCopyWithImpl<_$StateEntityImpl>(this, _$identity);
}

abstract class _StateEntity implements StateEntity {
  const factory _StateEntity(
      {required final String code,
      required final String name,
      required final String countryCode}) = _$StateEntityImpl;

  @override
  String get code;
  @override
  String get name;
  @override
  String get countryCode;
  @override
  @JsonKey(ignore: true)
  _$$StateEntityImplCopyWith<_$StateEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
