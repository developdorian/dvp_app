import 'package:dartz/dartz.dart';
import 'package:dvp_app/core/errors/failures.dart';
import 'package:dvp_app/features/home/domain/usecases/delete_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late DeleteUser usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = DeleteUser(mockUserRepository);
  });

  const tIndex = 0;

  test('should delete user at given index successfully', () async {
    // arrange
    when(mockUserRepository.deleteUser(any))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tIndex);

    // assert
    expect(result, const Right(null));
    verify(mockUserRepository.deleteUser(tIndex));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return CacheFailure when delete operation fails', () async {
    // arrange
    const tFailure = CacheFailure('Failed to delete user');
    when(mockUserRepository.deleteUser(any))
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tIndex);

    // assert
    expect(result, const Left(tFailure));
    verify(mockUserRepository.deleteUser(tIndex));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should pass correct index to repository', () async {
    // arrange
    const tDifferentIndex = 5;
    when(mockUserRepository.deleteUser(tDifferentIndex))
        .thenAnswer((_) async => const Right(null));

    // act
    await usecase(tDifferentIndex);

    // assert
    verify(mockUserRepository.deleteUser(tDifferentIndex));
    verifyNever(mockUserRepository.deleteUser(tIndex));
  });

  test('should handle deletion at index 0', () async {
    // arrange
    when(mockUserRepository.deleteUser(0))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(0);

    // assert
    expect(result, const Right(null));
    verify(mockUserRepository.deleteUser(0));
  });

  test('should handle deletion at large index', () async {
    // arrange
    const tLargeIndex = 999;
    when(mockUserRepository.deleteUser(tLargeIndex))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tLargeIndex);

    // assert
    expect(result, const Right(null));
    verify(mockUserRepository.deleteUser(tLargeIndex));
  });
}
