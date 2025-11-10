// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateModel _$StateModelFromJson(Map<String, dynamic> json) => StateModel(
      code: json['code'] as String,
      name: json['name'] as String,
      countryCode: json['countryCode'] as String,
    );

Map<String, dynamic> _$StateModelToJson(StateModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'countryCode': instance.countryCode,
    };
