import 'package:dartz/dartz.dart';
import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/features/form/domain/entities/city.dart';
import 'package:dvp_app/features/form/domain/usecases/get_cities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetCities usecase;
  late MockGeoRepository mockGeoRepository;

  setUp(() {
    mockGeoRepository = MockGeoRepository();
    usecase = GetCities(mockGeoRepository);
  });

  const tCountryCode = 'CO';
  const tStateCode = 'ANT';
  final tParams = GetCitiesParams(
    countryCode: tCountryCode,
    stateCode: tStateCode,
  );

  const tCities = [
    City(name: 'Medellín', stateCode: 'ANT', countryCode: 'CO'),
    City(name: 'Envigado', stateCode: 'ANT', countryCode: 'CO'),
    City(name: 'Bello', stateCode: 'ANT', countryCode: 'CO'),
  ];

  test('should get list of cities from the repository for given country and state', () async {
    // arrange
    when(mockGeoRepository.getCities(tCountryCode, tStateCode))
        .thenAnswer((_) async => const Right(tCities));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(tCities));
    verify(mockGeoRepository.getCities(tCountryCode, tStateCode));
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // arrange
    const tFailure = ServerFailure('Server error');
    when(mockGeoRepository.getCities(tCountryCode, tStateCode))
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(tFailure));
    verify(mockGeoRepository.getCities(tCountryCode, tStateCode));
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should return empty list when no cities available', () async {
    // arrange
    when(mockGeoRepository.getCities(tCountryCode, tStateCode))
        .thenAnswer((_) async => const Right(<City>[]));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(<City>[]));
    verify(mockGeoRepository.getCities(tCountryCode, tStateCode));
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should pass correct parameters to repository', () async {
    // arrange
    const tDifferentCountryCode = 'US';
    const tDifferentStateCode = 'CA';
    final tDifferentParams = GetCitiesParams(
      countryCode: tDifferentCountryCode,
      stateCode: tDifferentStateCode,
    );
    when(mockGeoRepository.getCities(tDifferentCountryCode, tDifferentStateCode))
        .thenAnswer((_) async => const Right(<City>[]));

    // act
    await usecase(tDifferentParams);

    // assert
    verify(mockGeoRepository.getCities(tDifferentCountryCode, tDifferentStateCode));
    verifyNever(mockGeoRepository.getCities(tCountryCode, tStateCode));
  });

  group('GetCitiesParams', () {
    test('should be equal when all properties are the same', () {
      // arrange
      final params1 = GetCitiesParams(countryCode: 'CO', stateCode: 'ANT');
      final params2 = GetCitiesParams(countryCode: 'CO', stateCode: 'ANT');

      // assert
      expect(params1, equals(params2));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final params1 = GetCitiesParams(countryCode: 'CO', stateCode: 'ANT');
      final params2 = GetCitiesParams(countryCode: 'CO', stateCode: 'CUN');

      // assert
      expect(params1, isNot(equals(params2)));
    });

    test('should have same hashCode when all properties are the same', () {
      // arrange
      final params1 = GetCitiesParams(countryCode: 'CO', stateCode: 'ANT');
      final params2 = GetCitiesParams(countryCode: 'CO', stateCode: 'ANT');

      // assert
      expect(params1.hashCode, equals(params2.hashCode));
    });

    test('should have different hashCode when properties differ', () {
      // arrange
      final params1 = GetCitiesParams(countryCode: 'CO', stateCode: 'ANT');
      final params2 = GetCitiesParams(countryCode: 'US', stateCode: 'CA');

      // assert
      expect(params1.hashCode, isNot(equals(params2.hashCode)));
    });
  });
}
