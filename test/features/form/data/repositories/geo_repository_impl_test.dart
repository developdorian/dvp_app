import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/features/form/data/models/city_model.dart';
import 'package:dvp_app/features/form/data/models/country_model.dart';
import 'package:dvp_app/features/form/data/models/state_model.dart';
import 'package:dvp_app/features/form/data/repositories/geo_repository_impl.dart';
import 'package:dvp_app/features/form/domain/entities/city.dart';
import 'package:dvp_app/features/form/domain/entities/country.dart';
import 'package:dvp_app/features/form/domain/entities/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GeoRepositoryImpl repository;
  late MockGeoRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockGeoRemoteDataSource();
    repository = GeoRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getCountries', () {
    final tCountryModels = [
      CountryModel(code: 'CO', name: 'Colombia'),
      CountryModel(code: 'US', name: 'United States'),
    ];

    const tCountryEntities = [
      Country(code: 'CO', name: 'Colombia'),
      Country(code: 'US', name: 'United States'),
    ];

    test('should return list of Country entities when call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getCountries())
          .thenAnswer((_) async => tCountryModels);

      // act
      final result = await repository.getCountries();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (countries) {
          expect(countries.length, tCountryEntities.length);
          expect(countries[0].code, tCountryEntities[0].code);
          expect(countries[1].name, tCountryEntities[1].name);
        },
      );
      verify(mockRemoteDataSource.getCountries());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when call to remote data source throws exception', () async {
      // arrange
      when(mockRemoteDataSource.getCountries())
          .thenThrow(Exception('Network error'));

      // act
      final result = await repository.getCountries();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Exception: Network error'));
        },
        (_) => fail('Should return Left'),
      );
      verify(mockRemoteDataSource.getCountries());
    });

    test('should return empty list when remote data source returns empty list', () async {
      // arrange
      when(mockRemoteDataSource.getCountries())
          .thenAnswer((_) async => []);

      // act
      final result = await repository.getCountries();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (countries) => expect(countries.length, 0),
      );
    });
  });

  group('getStates', () {
    const tCountryCode = 'CO';
    final tStateModels = [
      StateModel(code: 'ANT', name: 'Antioquia', countryCode: 'CO'),
      StateModel(code: 'CUN', name: 'Cundinamarca', countryCode: 'CO'),
    ];

    const tStateEntities = [
      StateEntity(code: 'ANT', name: 'Antioquia', countryCode: 'CO'),
      StateEntity(code: 'CUN', name: 'Cundinamarca', countryCode: 'CO'),
    ];

    test('should return list of StateEntity when call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getStates(tCountryCode))
          .thenAnswer((_) async => tStateModels);

      // act
      final result = await repository.getStates(tCountryCode);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (states) {
          expect(states.length, tStateEntities.length);
          expect(states[0].code, tStateEntities[0].code);
          expect(states[1].name, tStateEntities[1].name);
        },
      );
      verify(mockRemoteDataSource.getStates(tCountryCode));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when call to remote data source throws exception', () async {
      // arrange
      when(mockRemoteDataSource.getStates(tCountryCode))
          .thenThrow(Exception('API error'));

      // act
      final result = await repository.getStates(tCountryCode);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Exception: API error'));
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should return empty list when no states available', () async {
      // arrange
      when(mockRemoteDataSource.getStates(tCountryCode))
          .thenAnswer((_) async => []);

      // act
      final result = await repository.getStates(tCountryCode);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (states) => expect(states.length, 0),
      );
    });
  });

  group('getCities', () {
    const tCountryCode = 'CO';
    const tStateCode = 'ANT';
    final tCityModels = [
      CityModel(name: 'Medellín', stateCode: 'ANT', countryCode: 'CO'),
      CityModel(name: 'Envigado', stateCode: 'ANT', countryCode: 'CO'),
    ];

    const tCityEntities = [
      City(name: 'Medellín', stateCode: 'ANT', countryCode: 'CO'),
      City(name: 'Envigado', stateCode: 'ANT', countryCode: 'CO'),
    ];

    test('should return list of City entities when call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getCities(tCountryCode, tStateCode))
          .thenAnswer((_) async => tCityModels);

      // act
      final result = await repository.getCities(tCountryCode, tStateCode);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (cities) {
          expect(cities.length, tCityEntities.length);
          expect(cities[0].name, tCityEntities[0].name);
          expect(cities[1].name, tCityEntities[1].name);
        },
      );
      verify(mockRemoteDataSource.getCities(tCountryCode, tStateCode));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when call to remote data source throws exception', () async {
      // arrange
      when(mockRemoteDataSource.getCities(tCountryCode, tStateCode))
          .thenThrow(Exception('Connection timeout'));

      // act
      final result = await repository.getCities(tCountryCode, tStateCode);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Exception: Connection timeout'));
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should return empty list when no cities available', () async {
      // arrange
      when(mockRemoteDataSource.getCities(tCountryCode, tStateCode))
          .thenAnswer((_) async => []);

      // act
      final result = await repository.getCities(tCountryCode, tStateCode);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (cities) => expect(cities.length, 0),
      );
    });

    test('should handle different error types', () async {
      // arrange
      when(mockRemoteDataSource.getCities(tCountryCode, tStateCode))
          .thenThrow('String error');

      // act
      final result = await repository.getCities(tCountryCode, tStateCode);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should return Left'),
      );
    });
  });
}
