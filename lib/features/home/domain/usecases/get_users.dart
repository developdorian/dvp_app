import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../form/domain/entities/user.dart';
import '../../../form/domain/repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, List<User>>> call() async {
    return await repository.getUsers();
  }
}
