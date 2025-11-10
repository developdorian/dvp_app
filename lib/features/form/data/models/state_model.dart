import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/state.dart';

part 'state_model.g.dart';

@JsonSerializable()
class StateModel {
  final String code;
  final String name;
  final String countryCode;

  StateModel({
    required this.code,
    required this.name,
    required this.countryCode,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) =>
      _$StateModelFromJson(json);

  Map<String, dynamic> toJson() => _$StateModelToJson(this);

  StateEntity toEntity() {
    return StateEntity(
      code: code,
      name: name,
      countryCode: countryCode,
    );
  }
}
