import 'package:flutter/material.dart';
import '../../../controllers/edit_profile_controller.dart';
import '../../../controllers/questionnaire_controller.dart'; // Untuk akses konstanta
import '../../widgets/edit_target_goals/picker_trigger_field.dart';

class ActivityGoalSection extends StatelessWidget {
  final EditProfileController controller;

  const ActivityGoalSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const activityOptions = QuestionnaireController.activityLevelOptions;
    const goalOptions = QuestionnaireController.dietGoalOptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileController.buildSectionTitle('Aktivitas & Tujuan'),
        PickerTriggerField(
          label: 'Tingkat Aktivitas',
          value: controller.editedData['activityLevel'] ?? 'Pilih Tingkat Aktivitas',
          onTap: () => controller.showChoicePicker(context, 'activityLevel', 'Pilih Tingkat Aktivitas', activityOptions),
        ),
        const SizedBox(height: 15),
        PickerTriggerField(
          label: 'Tujuan Diet',
          value: controller.editedData['goals'] ?? 'Pilih Tujuan Diet',
          onTap: () => controller.showChoicePicker(context, 'goals', 'Pilih Tujuan Diet', goalOptions),
        ),
      ],
    );
  }
}