import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/geo_remote_datasource.dart';
import '../../data/datasources/user_local_datasource.dart';
import '../../data/repositories/geo_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/geo_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_countries.dart';
import '../../domain/usecases/get_states.dart';
import '../../domain/usecases/get_cities.dart';
import '../../domain/usecases/save_user.dart';
import '../../../../core/usecases/usecase.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) => Dio());

// Data sources
final geoRemoteDataSourceProvider = Provider<GeoRemoteDataSource>((ref) {
  return GeoRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  return UserLocalDataSourceImpl();
});

// Repositories
final geoRepositoryProvider = Provider<GeoRepository>((ref) {
  return GeoRepositoryImpl(
    remoteDataSource: ref.watch(geoRemoteDataSourceProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    localDataSource: ref.watch(userLocalDataSourceProvider),
  );
});

// Use cases
final getCountriesProvider = Provider<GetCountries>((ref) {
  return GetCountries(ref.watch(geoRepositoryProvider));
});

final getStatesProvider = Provider<GetStates>((ref) {
  return GetStates(ref.watch(geoRepositoryProvider));
});

final getCitiesProvider = Provider<GetCities>((ref) {
  return GetCities(ref.watch(geoRepositoryProvider));
});

final saveUserProvider = Provider<SaveUser>((ref) {
  return SaveUser(ref.watch(userRepositoryProvider));
});
