import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_cities.dart';
import '../providers/form_state_provider.dart';
import '../providers/form_providers.dart';

class AddressSection extends ConsumerWidget {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
    final selectedState = ref.watch(selectedStateProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final addressLine = ref.watch(addressLineProvider);
    final canAddAddress = ref.watch(canAddAddressProvider);
    final isSection2Valid = ref.watch(isSection2ValidProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  ref.read(formSectionProvider.notifier).state = 0;
                },
              ),
              const Text(
                'Direcciones',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // List of added addresses
          if (addresses.isNotEmpty) ...[
            const Text(
              'Direcciones agregadas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...addresses.asMap().entries.map((entry) {
              final index = entry.key;
              final address = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text('${address.city}, ${address.state}'),
                  subtitle: Text('${address.addressLine}\n${address.country}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      final updatedAddresses = List<Address>.from(addresses);
                      updatedAddresses.removeAt(index);
                      ref.read(addressesProvider.notifier).state = updatedAddresses;
                    },
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
          ],

          // Add new address form
          const Text(
            'Agregar nueva dirección:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          
          // Country dropdown
          _buildCountryDropdown(ref),
          const SizedBox(height: 16),
          
          // State dropdown
          if (selectedCountry != null) ...[
            _buildStateDropdown(ref, selectedCountry.code),
            const SizedBox(height: 16),
          ],
          
          // City dropdown
          if (selectedState != null) ...[
            _buildCityDropdown(ref, selectedCountry!.code, selectedState.code),
            const SizedBox(height: 16),
          ],
          
          // Address line
          if (selectedCity != null) ...[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
                hintText: 'Ej: Calle 123 #45-67',
              ),
              onChanged: (value) {
                ref.read(addressLineProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Add address button
          ElevatedButton.icon(
            onPressed: canAddAddress
                ? () {
                    final newAddress = Address(
                      country: selectedCountry!.name,
                      countryCode: selectedCountry.code,
                      state: selectedState!.name,
                      stateCode: selectedState.code,
                      city: selectedCity!.name,
                      addressLine: addressLine,
                    );
                    
                    final updatedAddresses = [...addresses, newAddress];
                    ref.read(addressesProvider.notifier).state = updatedAddresses;
                    
                    // Reset form
                    ref.read(selectedCountryProvider.notifier).state = null;
                    ref.read(selectedStateProvider.notifier).state = null;
                    ref.read(selectedCityProvider.notifier).state = null;
                    ref.read(addressLineProvider.notifier).state = '';
                  }
                : null,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Dirección'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 24),
          
          // Submit button
          ElevatedButton(
            onPressed: isSection2Valid
                ? () async {
                    await _saveUser(context, ref);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Agregar Usuario',
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (!isSection2Valid)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Debes agregar al menos una dirección',
                style: TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

    return countriesAsync.when(
      data: (countries) {
        if (countries.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No se encontraron países disponibles'),
            ),
          );
        }
        return DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'País',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.public),
          ),
          value: selectedCountry,
          items: countries.map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(country.name),
            );
          }).toList(),
          onChanged: (value) {
            ref.read(selectedCountryProvider.notifier).state = value;
            ref.read(selectedStateProvider.notifier).state = null;
            ref.read(selectedCityProvider.notifier).state = null;
          },
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Cargando países...'),
            ],
          ),
        ),
      ),
      error: (error, stack) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Error al cargar países',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 4),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateDropdown(WidgetRef ref, String countryCode) {
    final statesAsync = ref.watch(statesProvider(countryCode));
    final selectedState = ref.watch(selectedStateProvider);

    return statesAsync.when(
      data: (states) {
        if (states.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No se encontraron departamentos/estados para este país'),
            ),
          );
        }
        return DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'Departamento/Estado',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_city),
          ),
          value: selectedState,
          items: states.map((state) {
            return DropdownMenuItem(
              value: state,
              child: Text(state.name),
            );
          }).toList(),
          onChanged: (value) {
            ref.read(selectedStateProvider.notifier).state = value;
            ref.read(selectedCityProvider.notifier).state = null;
          },
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Cargando departamentos...'),
            ],
          ),
        ),
      ),
      error: (error, stack) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Error al cargar departamentos',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 4),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown(WidgetRef ref, String countryCode, String stateCode) {
    final citiesAsync = ref.watch(citiesProvider(
      GetCitiesParams(countryCode: countryCode, stateCode: stateCode),
    ));
    final selectedCity = ref.watch(selectedCityProvider);

    return citiesAsync.when(
      data: (cities) {
        if (cities.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No se encontraron ciudades para este departamento/estado'),
            ),
          );
        }
        return DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'Ciudad/Municipio',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          value: selectedCity,
          items: cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city.name),
            );
          }).toList(),
          onChanged: (value) {
            ref.read(selectedCityProvider.notifier).state = value;
          },
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Cargando ciudades...'),
            ],
          ),
        ),
      ),
      error: (error, stack) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Error al cargar ciudades',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 4),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUser(BuildContext context, WidgetRef ref) async {
    final firstName = ref.read(firstNameProvider);
    final lastName = ref.read(lastNameProvider);
    final birthDate = ref.read(birthDateProvider)!;
    final addresses = ref.read(addressesProvider);

    final saveUser = ref.read(saveUserProvider);
    final user = User(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      addresses: addresses,
    );

    final result = await saveUser(user);
    
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${failure.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Reset form
        ref.read(formSectionProvider.notifier).state = 0;
        ref.read(firstNameProvider.notifier).state = '';
        ref.read(lastNameProvider.notifier).state = '';
        ref.read(birthDateProvider.notifier).state = null;
        ref.read(addressesProvider.notifier).state = [];
      },
    );
  }
}
