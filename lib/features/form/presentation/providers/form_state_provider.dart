import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/state.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/get_cities.dart';
import '../../../../core/usecases/usecase.dart';
import 'form_providers.dart';

// Form section state
final formSectionProvider = StateProvider<int>((ref) => 0);

// Personal data state
final firstNameProvider = StateProvider<String>((ref) => '');
final lastNameProvider = StateProvider<String>((ref) => '');
final birthDateProvider = StateProvider<DateTime?>((ref) => null);

// Address list state
final addressesProvider = StateProvider<List<Address>>((ref) => []);

// Current address being edited
final selectedCountryProvider = StateProvider<Country?>((ref) => null);
final selectedStateProvider = StateProvider<StateEntity?>((ref) => null);
final selectedCityProvider = StateProvider<City?>((ref) => null);
final addressLineProvider = StateProvider<String>((ref) => '');

// Geo data providers with cache to prevent excessive API calls
final countriesProvider = FutureProvider<List<Country>>((ref) async {
  // Keep the provider alive to cache the result
  ref.keepAlive();
  
  final getCountries = ref.read(getCountriesProvider);
  final result = await getCountries(NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (countries) => countries,
  );
});

final statesProvider = FutureProvider.family<List<StateEntity>, String>((ref, countryCode) async {
  // Keep the provider alive to cache the result per country
  ref.keepAlive();
  
  // Add delay to respect rate limit (1 request/second)
  await Future.delayed(const Duration(milliseconds: 1100));
  
  final getStates = ref.read(getStatesProvider);
  final result = await getStates(countryCode);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (states) => states,
  );
});

final citiesProvider = FutureProvider.family<List<City>, GetCitiesParams>((ref, params) async {
  // Keep the provider alive to cache the result per country/state combination
  ref.keepAlive();
  
  // Add delay to respect rate limit (1 request/second)
  await Future.delayed(const Duration(milliseconds: 1100));
  
  final getCities = ref.read(getCitiesProvider);
  final result = await getCities(params);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (cities) => cities,
  );
});

// Form validation
final isSection1ValidProvider = Provider<bool>((ref) {
  final firstName = ref.watch(firstNameProvider);
  final lastName = ref.watch(lastNameProvider);
  final birthDate = ref.watch(birthDateProvider);

  if (firstName.trim().isEmpty || lastName.trim().isEmpty || birthDate == null) {
    return false;
  }

  // Check if birth date is not in the future
  if (birthDate.isAfter(DateTime.now())) {
    return false;
  }

  return true;
});

final isSection2ValidProvider = Provider<bool>((ref) {
  final addresses = ref.watch(addressesProvider);
  return addresses.isNotEmpty;
});

final canAddAddressProvider = Provider<bool>((ref) {
  final country = ref.watch(selectedCountryProvider);
  final state = ref.watch(selectedStateProvider);
  final city = ref.watch(selectedCityProvider);
  final addressLine = ref.watch(addressLineProvider);

  return country != null &&
      state != null &&
      city != null &&
      addressLine.trim().isNotEmpty;
});
