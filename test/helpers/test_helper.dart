import 'package:mockito/annotations.dart';
import 'package:dvp_app/features/form/domain/repositories/geo_repository.dart';
import 'package:dvp_app/features/form/domain/repositories/user_repository.dart';
import 'package:dvp_app/features/form/data/datasources/geo_remote_datasource.dart';
import 'package:dvp_app/features/form/data/datasources/user_local_datasource.dart';
import 'package:dio/dio.dart';

@GenerateMocks([
  GeoRepository,
  UserRepository,
  GeoRemoteDataSource,
  UserLocalDataSource,
  Dio,
])
void main() {}
