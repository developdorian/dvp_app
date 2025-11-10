import 'package:dvp_app/features/form/domain/entities/address.dart';
import 'package:dvp_app/features/form/presentation/providers/form_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Name Validation', () {
    test('should return false for empty first name', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = '';
      final isValid = container.read(isFirstNameValidProvider);

      expect(isValid, false);
    });

    test('should return false for first name with only spaces', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = '   ';
      final isValid = container.read(isFirstNameValidProvider);

      expect(isValid, false);
    });

    test('should return true for valid first name', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'Juan';
      final isValid = container.read(isFirstNameValidProvider);

      expect(isValid, true);
    });

    test('should return true for first name with accents', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'José María';
      final isValid = container.read(isFirstNameValidProvider);

      expect(isValid, true);
    });

    test('should return true for first name with hyphen', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'María-José';
      final isValid = container.read(isFirstNameValidProvider);

      expect(isValid, true);
    });

    test('should return false for first name with numbers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'Juan123';
      final isValid = container.read(isFirstNameValidProvider);

      expect(isValid, false);
    });

    test('should return false for first name with special characters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'Juan@#';
      final isValid = container.read(isFirstNameValidProvider);

      expect(isValid, false);
    });

    test('should return true for valid last name', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(lastNameProvider.notifier).state = 'Pérez García';
      final isValid = container.read(isLastNameValidProvider);

      expect(isValid, true);
    });

    test('should return false for empty last name', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(lastNameProvider.notifier).state = '';
      final isValid = container.read(isLastNameValidProvider);

      expect(isValid, false);
    });
  });

  group('Age Calculation', () {
    test('should calculate correct age for person born 30 years ago', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      final birthDate = DateTime(now.year - 30, now.month, now.day);
      container.read(birthDateProvider.notifier).state = birthDate;

      final age = container.read(calculatedAgeProvider);

      expect(age, 30);
    });

    test('should calculate correct age when birthday has not occurred this year', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      final birthDate = DateTime(now.year - 25, now.month + 1, now.day);
      container.read(birthDateProvider.notifier).state = birthDate;

      final age = container.read(calculatedAgeProvider);

      expect(age, 24);
    });

    test('should calculate correct age when birthday has occurred this year', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      final birthDate = DateTime(now.year - 25, now.month - 1, now.day);
      container.read(birthDateProvider.notifier).state = birthDate;

      final age = container.read(calculatedAgeProvider);

      expect(age, 25);
    });

    test('should return null when birth date is not set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final age = container.read(calculatedAgeProvider);

      expect(age, null);
    });
  });

  group('Section 1 Validation', () {
    test('should return false when first name is invalid', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = '';
      container.read(lastNameProvider.notifier).state = 'Pérez';
      container.read(birthDateProvider.notifier).state = DateTime(2000, 1, 1);

      final isValid = container.read(isSection1ValidProvider);

      expect(isValid, false);
    });

    test('should return false when last name is invalid', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'Juan';
      container.read(lastNameProvider.notifier).state = '';
      container.read(birthDateProvider.notifier).state = DateTime(2000, 1, 1);

      final isValid = container.read(isSection1ValidProvider);

      expect(isValid, false);
    });

    test('should return false when birth date is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'Juan';
      container.read(lastNameProvider.notifier).state = 'Pérez';
      container.read(birthDateProvider.notifier).state = null;

      final isValid = container.read(isSection1ValidProvider);

      expect(isValid, false);
    });

    test('should return false when birth date is in the future', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'Juan';
      container.read(lastNameProvider.notifier).state = 'Pérez';
      container.read(birthDateProvider.notifier).state = DateTime.now().add(const Duration(days: 1));

      final isValid = container.read(isSection1ValidProvider);

      expect(isValid, false);
    });

    test('should return false when age is less than 8 years', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      container.read(firstNameProvider.notifier).state = 'Juan';
      container.read(lastNameProvider.notifier).state = 'Pérez';
      container.read(birthDateProvider.notifier).state = DateTime(now.year - 7, now.month, now.day);

      final isValid = container.read(isSection1ValidProvider);

      expect(isValid, false);
    });

    test('should return true when all fields are valid and age is 8 or more', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      container.read(firstNameProvider.notifier).state = 'Juan';
      container.read(lastNameProvider.notifier).state = 'Pérez';
      container.read(birthDateProvider.notifier).state = DateTime(now.year - 8, now.month, now.day);

      final isValid = container.read(isSection1ValidProvider);

      expect(isValid, true);
    });

    test('should return true for valid adult user', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(firstNameProvider.notifier).state = 'María';
      container.read(lastNameProvider.notifier).state = 'García';
      container.read(birthDateProvider.notifier).state = DateTime(1990, 5, 15);

      final isValid = container.read(isSection1ValidProvider);

      expect(isValid, true);
    });
  });

  group('Section 2 Validation', () {
    test('should return false when no addresses are added', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final isValid = container.read(isSection2ValidProvider);

      expect(isValid, false);
    });

    test('should return true when at least one address is added', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(addressesProvider.notifier).state = const [
        Address(
          country: 'Colombia',
          countryCode: 'CO',
          state: 'Antioquia',
          stateCode: 'ANT',
          city: 'Medellín',
          addressLine: 'Calle 10 # 20-30',
        ),
      ];

      final isValid = container.read(isSection2ValidProvider);

      expect(isValid, true);
    });

    test('should return true when multiple addresses are added', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(addressesProvider.notifier).state = const [
        Address(
          country: 'Colombia',
          countryCode: 'CO',
          state: 'Antioquia',
          stateCode: 'ANT',
          city: 'Medellín',
          addressLine: 'Calle 10 # 20-30',
        ),
        Address(
          country: 'Colombia',
          countryCode: 'CO',
          state: 'Cundinamarca',
          stateCode: 'CUN',
          city: 'Bogotá',
          addressLine: 'Carrera 7 # 32-16',
        ),
      ];

      final isValid = container.read(isSection2ValidProvider);

      expect(isValid, true);
    });
  });

  group('Can Add Address Validation', () {
    test('should return false when country is not selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(selectedCountryProvider.notifier).state = null;
      container.read(addressLineProvider.notifier).state = 'Calle 10';

      final canAdd = container.read(canAddAddressProvider);

      expect(canAdd, false);
    });

    test('should return false when state is not selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(selectedStateProvider.notifier).state = null;
      container.read(addressLineProvider.notifier).state = 'Calle 10';

      final canAdd = container.read(canAddAddressProvider);

      expect(canAdd, false);
    });

    test('should return false when city is not selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(selectedCityProvider.notifier).state = null;
      container.read(addressLineProvider.notifier).state = 'Calle 10';

      final canAdd = container.read(canAddAddressProvider);

      expect(canAdd, false);
    });

    test('should return false when address line is empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(addressLineProvider.notifier).state = '';

      final canAdd = container.read(canAddAddressProvider);

      expect(canAdd, false);
    });

    test('should return false when address line is only spaces', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(addressLineProvider.notifier).state = '   ';

      final canAdd = container.read(canAddAddressProvider);

      expect(canAdd, false);
    });
  });
}
