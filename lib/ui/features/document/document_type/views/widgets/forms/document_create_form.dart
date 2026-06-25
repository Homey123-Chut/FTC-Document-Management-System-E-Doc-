import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/document_type/controllers/create_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/inputs/date_picker.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_dropdown_field.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_input_field.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_upload_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentCreateForm extends StatelessWidget {
  final CreateDocumentController controller;
  final _formKey = GlobalKey<FormState>();

  DocumentCreateForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Text('បង្កើតឯកសារ', style: AppTextStyles.heading4),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        label: 'ចំណងជើង',
                        controller: controller.titleController,
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: 'ចំណងជើងឡាតាំង',
                        controller: controller.subTitleController,
                      ),
                      const SizedBox(height: 16),

                      Obx(() => DropdownField(
                            label: 'ប្រភេទឯកសារ',
                            labelStyle: AppTextStyles.subtitle3,
                            selectedTextStyle: AppTextStyles.body1,
                            value: controller.selectedCategory.value,
                            items: controller.categories,
                            onChanged: controller.setCategory,
                            headerLabel: 'ប្រភេទឯកសារ',
                          )),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: 'លេខលិខិត',
                        controller: controller.refNumberController,
                      ),
                      const SizedBox(height: 16),

                      DatePicker(
                        label: 'កាលបរិច្ឆេទលិខិត',
                        controller: controller.dateController,
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: 'កម្មវត្ថុ',
                        controller: controller.taskController,
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: 'កម្មវិធី',
                        isRequired: false,
                        controller: controller.programController,
                      ),
                      const SizedBox(height: 16),

                      Obx(() {
                            // Read RxList inside Obx to establish dependency
                            final files =  List<AttachedFileInfo>.from(controller.attachedFiles);
                            return UploadField(
                              label: 'ឯកសារភ្ជាប់',
                              files: files,
                              onTap: controller.pickFile,
                              onRemove: controller.removeFile,
                              onTapFile: (index) =>
                                  controller.previewFile(context, index),
                            );
                          }),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () => Get.back(),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14)),
                                  side: const BorderSide(
                                      color: AppColors.grey),
                                ),
                                child: const Text('បោះបង់', style: TextStyle(color: AppColors.grey)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Obx(() => ButtonWidget(
                                  text: 'បង្កើត',
                                  isLoading: controller.isSubmitting.value,
                                  onPressed: controller.isSubmitting.value ? null : () => controller.submit(_formKey),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
