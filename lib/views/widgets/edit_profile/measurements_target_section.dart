import 'package:flutter/material.dart';
import '../../../controllers/edit_profile_controller.dart';
import '../../widgets/edit_target_goals/picker_trigger_field.dart';

class MeasurementsTargetSection extends StatelessWidget {
  final EditProfileController controller;

  const MeasurementsTargetSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileController.buildSectionTitle('Pengukuran & Target'),
        PickerTriggerField(
          label: 'Tinggi Badan',
          value: '${controller.editedData['height']} cm',
          onTap: () => controller.showPicker(context, 'height', 'Pilih Tinggi', 140, 220, unit: 'cm'),
        ),
        const SizedBox(height: 15),
        PickerTriggerField(
          label: 'Berat Badan Saat Ini',
          value: '${controller.editedData['currentWeight']} kg',
          onTap: () => controller.showPicker(context, 'currentWeight', 'Pilih Berat Saat Ini', 40, 150, unit: 'kg'),
        ),
        const SizedBox(height: 15),
        PickerTriggerField(
          label: 'Target Berat Badan',
          value: '${controller.editedData['goalWeight']} kg',
          onTap: () => controller.showPicker(context, 'goalWeight', 'Pilih Target Berat', 40, 150, unit: 'kg'),
        ),
      ],
    );
  }
}