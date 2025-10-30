import 'package:flutter/material.dart';
import '../../../controllers/edit_profile_controller.dart';
import '../../widgets/questionnaire/question_widgets.dart'; // Untuk GenderButton
import 'picker_trigger_field.dart';

class BasicInfoSection extends StatelessWidget {
  final EditProfileController controller;

  const BasicInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileController.buildSectionTitle('Informasi Dasar'),
        // Nama (Read Only)
        TextFormField(
          initialValue: controller.initialUser.name,
          readOnly: true,
          decoration: EditProfileController.inputDecoration(hintText: 'Nama Lengkap').copyWith(
            fillColor: Colors.grey.shade100,
          ),
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 15),
        // Email (Read Only)
        TextFormField(
          initialValue: controller.initialUser.email,
          readOnly: true,
          decoration: EditProfileController.inputDecoration(hintText: 'Email').copyWith(
            fillColor: Colors.grey.shade100,
          ),
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 15),
        // Jenis Kelamin
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenderButton(
              label: 'Pria',
              isSelected: controller.editedData['gender'] == 'Pria',
              onTap: () => controller.updateField('gender', 'Pria'),
            ),
            const SizedBox(width: 20),
            GenderButton(
              label: 'Wanita',
              isSelected: controller.editedData['gender'] == 'Wanita',
              onTap: () => controller.updateField('gender', 'Wanita'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Usia
        PickerTriggerField(
          label: 'Usia',
          value: '${controller.editedData['age']} tahun',
          onTap: () => controller.showPicker(context, 'age', 'Pilih Usia', 15, 80, unit: 'tahun'),
        ),
      ],
    );
  }
}