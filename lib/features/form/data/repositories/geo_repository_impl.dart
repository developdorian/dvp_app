import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/state.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/geo_repository.dart';
import '../datasources/geo_remote_datasource.dart';

class GeoRepositoryImpl implements GeoRepository {
  final GeoRemoteDataSource remoteDataSource;

  GeoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    try {
      final countries = await remoteDataSource.getCountries();
      return Right(countries.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StateEntity>>> getStates(String countryCode) async {
    try {
      final states = await remoteDataSource.getStates(countryCode);
      return Right(states.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<City>>> getCities(String countryCode, String stateCode) async {
    try {
      final cities = await remoteDataSource.getCities(countryCode, stateCode);
      return Right(cities.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
