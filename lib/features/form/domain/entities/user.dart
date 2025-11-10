import 'package:freezed_annotation/freezed_annotation.dart';
import 'address.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required List<Address> addresses,
  }) = _User;
}
