import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/form_state_provider.dart';

class PersonalDataSection extends ConsumerWidget {
  const PersonalDataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final birthDate = ref.watch(birthDateProvider);
    final isValid = ref.watch(isSection1ValidProvider);
    final calculatedAge = ref.watch(calculatedAgeProvider);
    final isFirstNameValid = ref.watch(isFirstNameValidProvider);
    final isLastNameValid = ref.watch(isLastNameValidProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Datos Personales',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: InputDecoration(
              labelText: 'Nombre',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              errorText: firstName.isNotEmpty && !isFirstNameValid
                  ? 'Solo se permiten letras'
                  : null,
            ),
            onChanged: (value) {
              ref.read(firstNameProvider.notifier).state = value;
            },
          ),
          if (firstName.isNotEmpty && !isFirstNameValid)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No se permiten números ni caracteres especiales',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Apellido',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person_outline),
              errorText: lastName.isNotEmpty && !isLastNameValid
                  ? 'Solo se permiten letras'
                  : null,
            ),
            onChanged: (value) {
              ref.read(lastNameProvider.notifier).state = value;
            },
          ),
          if (lastName.isNotEmpty && !isLastNameValid)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No se permiten números ni caracteres especiales',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: birthDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                helpText: 'Selecciona tu fecha de nacimiento',
              );
              if (picked != null) {
                ref.read(birthDateProvider.notifier).state = picked;
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                birthDate != null
                    ? DateFormat('dd/MM/yyyy').format(birthDate)
                    : 'Selecciona una fecha',
                style: TextStyle(
                  color: birthDate != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          if (birthDate != null) ...[
            if (birthDate.isAfter(DateTime.now()))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'La fecha de nacimiento no puede ser futura',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (calculatedAge != null && calculatedAge < 8)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edad mínima requerida',
                              style: TextStyle(
                                color: Colors.orange.shade900,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Debes tener al menos 8 años para registrarte. Edad actual: $calculatedAge ${calculatedAge == 1 ? 'año' : 'años'}.',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (calculatedAge != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green.shade600, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Edad: $calculatedAge ${calculatedAge == 1 ? 'año' : 'años'}',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: isValid
                ? () {
                    ref.read(formSectionProvider.notifier).state = 1;
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (!isValid && (firstName.isNotEmpty || lastName.isNotEmpty || birthDate != null))
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Por favor completa todos los campos correctamente',
                style: TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
