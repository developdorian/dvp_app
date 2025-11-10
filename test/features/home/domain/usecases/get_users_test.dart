import 'package:dartz/dartz.dart';
import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/features/form/domain/entities/address.dart';
import 'package:dvp_app/features/form/domain/entities/user.dart';
import 'package:dvp_app/features/home/domain/usecases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetUsers usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUsers(mockUserRepository);
  });

  final tUsers = [
    User(
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
    ),
    User(
      firstName: 'María',
      lastName: 'García',
      birthDate: DateTime(1985, 3, 20),
      addresses: const [
        Address(
          country: 'Colombia',
          countryCode: 'CO',
          state: 'Cundinamarca',
          stateCode: 'CUN',
          city: 'Bogotá',
          addressLine: 'Carrera 7 # 32-16',
        ),
      ],
    ),
  ];

  test('should get list of users from the repository', () async {
    // arrange
    when(mockUserRepository.getUsers())
        .thenAnswer((_) async => Right(tUsers));

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tUsers));
    verify(mockUserRepository.getUsers());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return CacheFailure when repository call fails', () async {
    // arrange
    const tFailure = CacheFailure('Failed to retrieve users');
    when(mockUserRepository.getUsers())
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(tFailure));
    verify(mockUserRepository.getUsers());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return empty list when no users are stored', () async {
    // arrange
    when(mockUserRepository.getUsers())
        .thenAnswer((_) async => const Right(<User>[]));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(<User>[]));
    verify(mockUserRepository.getUsers());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should call repository without parameters', () async {
    // arrange
    when(mockUserRepository.getUsers())
        .thenAnswer((_) async => const Right(<User>[]));

    // act
    await usecase();

    // assert
    verify(mockUserRepository.getUsers()).called(1);
  });
}
