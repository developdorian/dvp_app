import 'package:dartz/dartz.dart';
import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/core/usecases/usecase.dart';
import 'package:dvp_app/features/form/domain/entities/country.dart';
import 'package:dvp_app/features/form/domain/usecases/get_countries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetCountries usecase;
  late MockGeoRepository mockGeoRepository;

  setUp(() {
    mockGeoRepository = MockGeoRepository();
    usecase = GetCountries(mockGeoRepository);
  });

  const tCountries = [
    Country(code: 'CO', name: 'Colombia'),
    Country(code: 'US', name: 'United States'),
    Country(code: 'MX', name: 'Mexico'),
  ];

  test('should get list of countries from the repository', () async {
    // arrange
    when(mockGeoRepository.getCountries())
        .thenAnswer((_) async => const Right(tCountries));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(tCountries));
    verify(mockGeoRepository.getCountries());
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // arrange
    const tFailure = ServerFailure('Server error');
    when(mockGeoRepository.getCountries())
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Left(tFailure));
    verify(mockGeoRepository.getCountries());
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should return empty list when no countries available', () async {
    // arrange
    when(mockGeoRepository.getCountries())
        .thenAnswer((_) async => const Right(<Country>[]));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(<Country>[]));
    verify(mockGeoRepository.getCountries());
    verifyNoMoreInteractions(mockGeoRepository);
  });
}
