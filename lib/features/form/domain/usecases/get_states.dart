import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/state.dart';
import '../repositories/geo_repository.dart';

class GetStates implements UseCase<List<StateEntity>, String> {
  final GeoRepository repository;

  GetStates(this.repository);

  @override
  Future<Either<Failure, List<StateEntity>>> call(String countryCode) async {
    return await repository.getStates(countryCode);
  }
}
