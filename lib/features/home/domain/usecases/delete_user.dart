import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../form/domain/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, void>> call(int index) async {
    return await repository.deleteUser(index);
  }
}
