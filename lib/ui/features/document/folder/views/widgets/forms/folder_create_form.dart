import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/folder/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FolderCreateForm extends StatefulWidget {
  final FolderController controller;

  const FolderCreateForm({super.key, required this.controller});

  @override
  State<FolderCreateForm> createState() => _FolderCreateFormState();
}

class _FolderCreateFormState extends State<FolderCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Text(
                    "បង្កើតសំណុំឯកសារ",
                    style: AppTextStyles.heading4,
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldWidget(
                      label: "ឈ្មោះ៖",
                      controller: _nameController,
                      hintText: "សូមសរសេរឈ្មោះនៅទីនេះ៖",
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                side: const BorderSide(color: AppColors.grey),
                              ),
                              child: const Text('បោះបង់',
                                  style: TextStyle(color: AppColors.grey)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ButtonWidget(
                            text: "បង្កើត",
                            isLoading: controller.isCreating.value,
                            onPressed: controller.isCreating.value
                                ? null
                                : () => controller.submitFolder(
                                    _formKey, _nameController.text),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
