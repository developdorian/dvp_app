import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/country.dart';
import '../entities/state.dart';
import '../entities/city.dart';

abstract class GeoRepository {
  Future<Either<Failure, List<Country>>> getCountries();
  Future<Either<Failure, List<StateEntity>>> getStates(String countryCode);
  Future<Either<Failure, List<City>>> getCities(String countryCode, String stateCode);
}
