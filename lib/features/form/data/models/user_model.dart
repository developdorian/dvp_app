import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';
import 'address_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final DateTime birthDate;

  @HiveField(3)
  final List<AddressModel> addresses;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.addresses,
  });

  User toEntity() {
    return User(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      addresses: addresses.map((a) => a.toEntity()).toList(),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      firstName: user.firstName,
      lastName: user.lastName,
      birthDate: user.birthDate,
      addresses: user.addresses.map((a) => AddressModel.fromEntity(a)).toList(),
    );
  }
}
