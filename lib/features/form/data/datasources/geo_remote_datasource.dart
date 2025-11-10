import 'package:dio/dio.dart';
import '../models/country_model.dart';
import '../models/state_model.dart';
import '../models/city_model.dart';

abstract class GeoRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<List<StateModel>> getStates(String countryCode);
  Future<List<CityModel>> getCities(String countryCode, String stateCode);
}

class GeoRemoteDataSourceImpl implements GeoRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://wft-geo-db.p.rapidapi.com/v1/geo';
  static const String apiKey = '48cfa88389mshbfc9f79b43a78eap112ff6jsnc74cc7041a94';

  GeoRemoteDataSourceImpl({required this.dio}) {
    dio.options.headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
    };
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await dio.get('$baseUrl/countries', queryParameters: {
        'limit': 10,  // Free plan limit
      });
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CountryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('Error de autenticación con la API. Verifica tu API Key de RapidAPI.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Límite de velocidad excedido (1 req/seg). Espera un momento e intenta de nuevo.');
      }
      throw Exception('Error al cargar países: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<StateModel>> getStates(String countryCode) async {
    try {
      final response = await dio.get('$baseUrl/countries/$countryCode/regions', queryParameters: {
        'limit': 10,  // Free plan limit
      });
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => StateModel.fromJson({
        'code': json['isoCode'],
        'name': json['name'],
        'countryCode': countryCode,
      })).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('Error de autenticación con la API.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Límite de velocidad excedido. Espera un momento.');
      }
      throw Exception('Error al cargar departamentos: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<CityModel>> getCities(String countryCode, String stateCode) async {
    try {
      final response = await dio.get('$baseUrl/places', queryParameters: {
        'countryIds': countryCode,
        'regionCode': stateCode,
        'limit': 10,  // Free plan limit
        'types': 'CITY',
      });
      
      final List<dynamic> data = response.data['data'];

      if (data.isEmpty) {
        return [];
      }
      
      return data.map((json) => CityModel.fromJson({
        'name': json['name'],
        'stateCode': stateCode,
        'countryCode': countryCode,
      })).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('Error de autenticación con la API.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Límite de velocidad excedido. Espera un momento.');
      }
      throw Exception('Error al cargar ciudades: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
