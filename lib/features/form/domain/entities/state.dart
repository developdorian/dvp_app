import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class StateEntity with _$StateEntity {
  const factory StateEntity({
    required String code,
    required String name,
    required String countryCode,
  }) = _StateEntity;
}
