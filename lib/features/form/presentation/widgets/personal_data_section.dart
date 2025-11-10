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
            decoration: const InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (value) {
              ref.read(firstNameProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Apellido',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: (value) {
              ref.read(lastNameProvider.notifier).state = value;
            },
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
          if (birthDate != null && birthDate.isAfter(DateTime.now()))
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'La fecha de nacimiento no puede ser futura',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
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
