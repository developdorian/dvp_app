import 'package:dartz/dartz.dart';
import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/features/form/domain/entities/address.dart';
import 'package:dvp_app/features/form/domain/entities/user.dart';
import 'package:dvp_app/features/form/domain/usecases/save_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveUser usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SaveUser(mockUserRepository);
  });

  final tUser = User(
    firstName: 'Juan',
    lastName: 'Pérez',
    birthDate: DateTime(1990, 5, 15),
    addresses: const [
      Address(
        country: 'Colombia',
        countryCode: 'CO',
        state: 'Antioquia',
        stateCode: 'ANT',
        city: 'Medellín',
        addressLine: 'Calle 10 # 20-30',
      ),
    ],
  );

  test('should save user successfully through the repository', () async {
    // arrange
    when(mockUserRepository.saveUser(any))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tUser);

    // assert
    expect(result, const Right(null));
    verify(mockUserRepository.saveUser(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return CacheFailure when save operation fails', () async {
    // arrange
    const tFailure = CacheFailure('Failed to save user');
    when(mockUserRepository.saveUser(any))
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tUser);

    // assert
    expect(result, const Left(tFailure));
    verify(mockUserRepository.saveUser(tUser));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should save user with multiple addresses', () async {
    // arrange
    final tUserWithMultipleAddresses = User(
      firstName: 'María',
      lastName: 'García',
      birthDate: DateTime(1985, 3, 20),
      addresses: const [
        Address(
          country: 'Colombia',
          countryCode: 'CO',
          state: 'Antioquia',
          stateCode: 'ANT',
          city: 'Medellín',
          addressLine: 'Calle 10 # 20-30',
        ),
        Address(
          country: 'Colombia',
          countryCode: 'CO',
          state: 'Cundinamarca',
          stateCode: 'CUN',
          city: 'Bogotá',
          addressLine: 'Carrera 7 # 32-16',
        ),
      ],
    );
    when(mockUserRepository.saveUser(any))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tUserWithMultipleAddresses);

    // assert
    expect(result, const Right(null));
    verify(mockUserRepository.saveUser(tUserWithMultipleAddresses));
  });

  test('should pass exact user object to repository', () async {
    // arrange
    when(mockUserRepository.saveUser(tUser))
        .thenAnswer((_) async => const Right(null));

    // act
    await usecase(tUser);

    // assert
    final captured = verify(mockUserRepository.saveUser(captureAny)).captured;
    expect(captured.first, equals(tUser));
  });
}
