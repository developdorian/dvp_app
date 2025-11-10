import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required String country,
    required String countryCode,
    required String state,
    required String stateCode,
    required String city,
    required String addressLine,
  }) = _Address;
}
