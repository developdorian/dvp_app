import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/city.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  final String name;
  final String stateCode;
  final String countryCode;

  CityModel({
    required this.name,
    required this.stateCode,
    required this.countryCode,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  City toEntity() {
    return City(
      name: name,
      stateCode: stateCode,
      countryCode: countryCode,
    );
  }
}
