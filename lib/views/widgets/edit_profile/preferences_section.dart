import 'package:flutter/material.dart';
import '../../../controllers/edit_profile_controller.dart';
import '../../../controllers/questionnaire_controller.dart'; // Untuk akses konstanta
import 'picker_trigger_field.dart';

class PreferencesSection extends StatelessWidget {
  final EditProfileController controller;

  const PreferencesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const restrictionOptions = QuestionnaireController.dietaryRestrictionOptions;
    const allergyOptions = QuestionnaireController.allergyOptions;
    final List restrictions = controller.editedData['dietaryRestrictions'] ?? [];
    final List allergies = controller.editedData['allergies'] ?? [];


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileController.buildSectionTitle('Preferensi Makanan'),
        PickerTriggerField(
          label: 'Pantangan Makan',
          value: restrictions.isEmpty
              ? 'Tidak ada pantangan'
              : '${restrictions.length} pantangan dipilih',
          onTap: () => controller.showMultiSelectPicker(context, 'dietaryRestrictions', 'Pilih Pantangan Makan', restrictionOptions),
          trailingIcon: Icons.checklist_rtl,
        ),
        const SizedBox(height: 15),
        PickerTriggerField(
          label: 'Alergi Makanan',
          value: allergies.isEmpty
              ? 'Tidak ada alergi'
              : '${allergies.length} alergi dipilih',
          onTap: () => controller.showMultiSelectPicker(context, 'allergies', 'Pilih Alergi Makanan', allergyOptions),
          trailingIcon: Icons.checklist_rtl,
        ),
      ],
    );
  }
}