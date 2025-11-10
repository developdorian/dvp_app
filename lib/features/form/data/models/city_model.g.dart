// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
      name: json['name'] as String,
      stateCode: json['stateCode'] as String,
      countryCode: json['countryCode'] as String,
    );

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
      'name': instance.name,
      'stateCode': instance.stateCode,
      'countryCode': instance.countryCode,
    };
