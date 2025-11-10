import 'package:dartz/dartz.dart';
import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/features/form/data/models/address_model.dart';
import 'package:dvp_app/features/form/data/models/user_model.dart';
import 'package:dvp_app/features/form/data/repositories/user_repository_impl.dart';
import 'package:dvp_app/features/form/domain/entities/address.dart';
import 'package:dvp_app/features/form/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    repository = UserRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('saveUser', () {
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

    test('should save user successfully when call to local data source succeeds', () async {
      // arrange
      when(mockLocalDataSource.saveUser(any))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repository.saveUser(tUser);

      // assert
      expect(result, const Right(null));
      verify(mockLocalDataSource.saveUser(any));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when call to local data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.saveUser(any))
          .thenThrow(Exception('Storage error'));

      // act
      final result = await repository.saveUser(tUser);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Exception: Storage error'));
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should convert User entity to UserModel before saving', () async {
      // arrange
      when(mockLocalDataSource.saveUser(any))
          .thenAnswer((_) async => Future.value());

      // act
      await repository.saveUser(tUser);

      // assert
      final captured = verify(mockLocalDataSource.saveUser(captureAny)).captured;
      expect(captured.first, isA<UserModel>());
      final savedModel = captured.first as UserModel;
      expect(savedModel.firstName, tUser.firstName);
      expect(savedModel.lastName, tUser.lastName);
      expect(savedModel.birthDate, tUser.birthDate);
      expect(savedModel.addresses.length, tUser.addresses.length);
    });
  });

  group('getUsers', () {
    final tUserModels = [
      UserModel(
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [
          AddressModel(
            country: 'Colombia',
            countryCode: 'CO',
            state: 'Antioquia',
            stateCode: 'ANT',
            city: 'Medellín',
            addressLine: 'Calle 10 # 20-30',
          ),
        ],
      ),
      UserModel(
        firstName: 'María',
        lastName: 'García',
        birthDate: DateTime(1985, 3, 20),
        addresses: [
          AddressModel(
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

    final tUserEntities = [
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

    test('should return list of User entities when call to local data source is successful', () async {
      // arrange
      when(mockLocalDataSource.getUsers())
          .thenAnswer((_) async => tUserModels);

      // act
      final result = await repository.getUsers();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (users) {
          expect(users.length, tUserEntities.length);
          expect(users[0].firstName, tUserEntities[0].firstName);
          expect(users[1].firstName, tUserEntities[1].firstName);
        },
      );
      verify(mockLocalDataSource.getUsers());
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when call to local data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.getUsers())
          .thenThrow(Exception('Database error'));

      // act
      final result = await repository.getUsers();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Exception: Database error'));
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should return empty list when no users are stored', () async {
      // arrange
      when(mockLocalDataSource.getUsers())
          .thenAnswer((_) async => []);

      // act
      final result = await repository.getUsers();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (users) => expect(users.length, 0),
      );
    });
  });

  group('deleteUser', () {
    const tIndex = 0;

    test('should delete user successfully when call to local data source succeeds', () async {
      // arrange
      when(mockLocalDataSource.deleteUser(tIndex))
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repository.deleteUser(tIndex);

      // assert
      expect(result, const Right(null));
      verify(mockLocalDataSource.deleteUser(tIndex));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when call to local data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.deleteUser(tIndex))
          .thenThrow(Exception('Delete failed'));

      // act
      final result = await repository.deleteUser(tIndex);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Exception: Delete failed'));
        },
        (_) => fail('Should return Left'),
      );
    });

    test('should pass correct index to local data source', () async {
      // arrange
      const tDifferentIndex = 5;
      when(mockLocalDataSource.deleteUser(tDifferentIndex))
          .thenAnswer((_) async => Future.value());

      // act
      await repository.deleteUser(tDifferentIndex);

      // assert
      verify(mockLocalDataSource.deleteUser(tDifferentIndex));
      verifyNever(mockLocalDataSource.deleteUser(tIndex));
    });
  });
}
