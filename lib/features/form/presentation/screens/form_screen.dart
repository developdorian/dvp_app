import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/form_state_provider.dart';
import '../widgets/personal_data_section.dart';
import '../widgets/address_section.dart';

class FormScreen extends ConsumerWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSection = ref.watch(formSectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Usuario'),
      ),
      body: SingleChildScrollView(
        child: currentSection == 0
            ? const PersonalDataSection()
            : const AddressSection(),
      ),
    );
  }
}
