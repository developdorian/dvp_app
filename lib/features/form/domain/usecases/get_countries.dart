import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/geo_repository.dart';

class GetCountries implements UseCase<List<Country>, NoParams> {
  final GeoRepository repository;

  GetCountries(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) async {
    return await repository.getCountries();
  }
}
