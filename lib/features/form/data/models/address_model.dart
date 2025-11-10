import 'package:hive/hive.dart';
import '../../domain/entities/address.dart';

part 'address_model.g.dart';

@HiveType(typeId: 1)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String country;

  @HiveField(1)
  final String countryCode;

  @HiveField(2)
  final String state;

  @HiveField(3)
  final String stateCode;

  @HiveField(4)
  final String city;

  @HiveField(5)
  final String addressLine;

  AddressModel({
    required this.country,
    required this.countryCode,
    required this.state,
    required this.stateCode,
    required this.city,
    required this.addressLine,
  });

  Address toEntity() {
    return Address(
      country: country,
      countryCode: countryCode,
      state: state,
      stateCode: stateCode,
      city: city,
      addressLine: addressLine,
    );
  }

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      country: address.country,
      countryCode: address.countryCode,
      state: address.state,
      stateCode: address.stateCode,
      city: address.city,
      addressLine: address.addressLine,
    );
  }
}
