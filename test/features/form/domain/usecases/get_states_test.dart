import 'package:dartz/dartz.dart';
import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/features/form/domain/entities/state.dart';
import 'package:dvp_app/features/form/domain/usecases/get_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetStates usecase;
  late MockGeoRepository mockGeoRepository;

  setUp(() {
    mockGeoRepository = MockGeoRepository();
    usecase = GetStates(mockGeoRepository);
  });

  const tCountryCode = 'CO';
  const tStates = [
    StateEntity(code: 'ANT', name: 'Antioquia', countryCode: 'CO'),
    StateEntity(code: 'CUN', name: 'Cundinamarca', countryCode: 'CO'),
    StateEntity(code: 'VAC', name: 'Valle del Cauca', countryCode: 'CO'),
  ];

  test('should get list of states from the repository for a given country', () async {
    // arrange
    when(mockGeoRepository.getStates(tCountryCode))
        .thenAnswer((_) async => const Right(tStates));

    // act
    final result = await usecase(tCountryCode);

    // assert
    expect(result, const Right(tStates));
    verify(mockGeoRepository.getStates(tCountryCode));
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // arrange
    const tFailure = ServerFailure('Server error');
    when(mockGeoRepository.getStates(tCountryCode))
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tCountryCode);

    // assert
    expect(result, const Left(tFailure));
    verify(mockGeoRepository.getStates(tCountryCode));
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should return empty list when no states available for country', () async {
    // arrange
    when(mockGeoRepository.getStates(tCountryCode))
        .thenAnswer((_) async => const Right(<StateEntity>[]));

    // act
    final result = await usecase(tCountryCode);

    // assert
    expect(result, const Right(<StateEntity>[]));
    verify(mockGeoRepository.getStates(tCountryCode));
    verifyNoMoreInteractions(mockGeoRepository);
  });

  test('should pass correct country code to repository', () async {
    // arrange
    const tDifferentCountryCode = 'US';
    when(mockGeoRepository.getStates(tDifferentCountryCode))
        .thenAnswer((_) async => const Right(<StateEntity>[]));

    // act
    await usecase(tDifferentCountryCode);

    // assert
    verify(mockGeoRepository.getStates(tDifferentCountryCode));
    verifyNever(mockGeoRepository.getStates(tCountryCode));
  });
}
