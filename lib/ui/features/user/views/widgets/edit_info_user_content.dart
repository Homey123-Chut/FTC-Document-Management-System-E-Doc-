import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/views/widgets/profile_header_card.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_dropdown_field.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditInfoUserContent extends GetView<ProfileController> {
  const EditInfoUserContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value && controller.user.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.user.value;
      if (user == null) {
        return const Center(child: Text('មិនអាចទាញយកទិន្នន័យបានទេ'));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Profile header with camera
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
              child: Obx(() {
                final isUploading = controller.isUploadingImage.value;
                return ProfileHeaderCard(
                  imageUrl: controller.profileImageUrl,
                  roleLabel: controller.roleLabel,
                  userName: user.username,
                  entityLabel: 'អង្គភាព',
                  entityName: user.department,
                  onCameraTap: isUploading ? null : () => controller.pickAndUploadImage(),
                );
              }),
            ),

            const SizedBox(height: 6),

            //  Edit form 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //  Header row

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ព័ត៌មានអ្នកប្រើប្រាស់',
                          style: AppTextStyles.title5,
                        ),

                        TextButton.icon(
                          onPressed: controller.isSaving.value ? null : (controller.isEditing.value ? () => controller.saveProfile() : controller.toggleEdit),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEDF2F9),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: controller.isSaving.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  controller.isEditing.value
                                      ? Icons.check_circle_outline
                                      : Icons.edit_note_outlined,
                                  size: 20,
                                  color: AppColors.darkBlue,
                                ),
                          label: Text(
                            controller.isEditing.value ? 'រក្សាទុក' : 'កែប្រែ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    //  Form fields

                    TextFieldWidget(
                      label: 'ឈ្មោះ',
                      controller: controller.nameCtrl,
                      isRequired: false,
                      textStyle: AppTextStyles.label5,
                      labelStyle: AppTextStyles.label4,
                    ),
                    const SizedBox(height: 16),

                    DropdownField(
                      label: 'ភេទ',
                      labelStyle: AppTextStyles.label4,
                      selectedTextStyle: AppTextStyles.label5,
                      value: controller.editGender.value,
                      items: const ['Male', 'Female'],
                      onChanged: (v) {
                        if (v != null) controller.editGender.value = v;
                      },
                      headerLabel: 'សូមជ្រើសរើស',
                    ),

                    const SizedBox(height: 16),

                    TextFieldWidget(
                      label: 'លេខទូរស័ព្ទ',
                      controller: controller.phoneCtrl,
                      isRequired: false,
                      textStyle: AppTextStyles.label5,
                      labelStyle: AppTextStyles.label4,
                    ),
                    const SizedBox(height: 16),

                    TextFieldWidget(
                      label: 'អ៊ីមែល',
                      controller: controller.emailCtrl,
                      isRequired: false,
                      textStyle: AppTextStyles.label5,
                      labelStyle: AppTextStyles.label4,
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      return TextFieldWidget(
                        label: 'លេខសម្ងាត់',
                        controller: controller.passwordCtrl,
                        isRequired: false,
                        obscureText: controller.obscurePassword.value,
                        textStyle: AppTextStyles.label5,
                        labelStyle: AppTextStyles.label4,
                        suffixIcon: GestureDetector(
                          onTap: () => controller.obscurePassword.toggle(),
                          child: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: AppColors.darkGray,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                    Obx(() {
                      return DropdownField(
                        label: 'អង្គភាព',
                        labelStyle: AppTextStyles.label4,
                        selectedTextStyle: AppTextStyles.label5,
                        value: controller.editEntity.value,
                        items: controller.entityItems,
                        onChanged: (v) {
                          if (v != null) controller.editEntity.value = v;
                        },
                        headerLabel: 'សូមជ្រើសរើស',
                      );
                    }),
                    const SizedBox(height: 16),

                    DropdownField(
                      label: 'តួនាទី',
                      labelStyle: AppTextStyles.label4,
                      selectedTextStyle: AppTextStyles.label5,
                      value: controller.editRole.value,
                      items: ProfileController.roleItems,
                      onChanged: (v) {
                        if (v != null) controller.editRole.value = v;
                      },
                      headerLabel: 'សូមជ្រើសរើស',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
