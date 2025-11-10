import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/city.dart';
import '../repositories/geo_repository.dart';

class GetCitiesParams {
  final String countryCode;
  final String stateCode;

  GetCitiesParams({required this.countryCode, required this.stateCode});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetCitiesParams &&
        other.countryCode == countryCode &&
        other.stateCode == stateCode;
  }

  @override
  int get hashCode => countryCode.hashCode ^ stateCode.hashCode;
}

class GetCities implements UseCase<List<City>, GetCitiesParams> {
  final GeoRepository repository;

  GetCities(this.repository);

  @override
  Future<Either<Failure, List<City>>> call(GetCitiesParams params) async {
    return await repository.getCities(params.countryCode, params.stateCode);
  }
}
