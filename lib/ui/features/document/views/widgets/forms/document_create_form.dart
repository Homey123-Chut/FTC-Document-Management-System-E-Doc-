import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/controllers/document_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/inputs/date_picker.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_dropdown_field.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_input_field.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_upload_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dialog form for creating a new document within a specific [DocumentType].
/// Opens as a popup via [Get.dialog] on top of [DocumentTypeScreen].
/// On submit, creates a [DocumentModel] via [DocumentController] and closes.
class DocumentCreateForm extends StatefulWidget {
  final DocumentType type;

  const DocumentCreateForm({super.key, required this.type});

  @override
  State<DocumentCreateForm> createState() => _DocumentCreateFormState();
}

class _DocumentCreateFormState extends State<DocumentCreateForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController refNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController programController = TextEditingController();

  String _selectedCategory = 'ជម្រើស ១';
  String _attachmentName = '';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'ជម្រើស ១',
    'ជម្រើស ២',
    'ជម្រើស ៣',
  ];

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _attachmentName = file.name;
        });
      }
    } catch (e) {
      Get.snackbar(
        'មានបញ្ហា',
        'មិនអាចជ្រើសរើសឯកសារបានទេ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final controller = Get.find<DocumentController>(
        tag: 'doc_${widget.type.name}',
      );

      final newDoc = DocumentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        titleKhmer: titleController.text.trim(),
        titleLatin: subTitleController.text.trim(),
        documentNumber: refNumberController.text.trim(),
        date: dateController.text.trim(),
        status: 'កំពុងរង់ចាំ',
        subject: taskController.text.trim(),
        program: programController.text.trim(),
        documentHistory: 'បានបង្កើតថ្មី',
        attachedFile: _attachmentName,
      );

      await controller.createDocument(newDoc);
      if (mounted) {
        Get.back(); // close dialog
        Get.snackbar(
          'ជោគជ័យ',
          'ឯកសារត្រូវបានបង្កើតដោយជោគជ័យ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'មានបញ្ហា',
          'មិនអាចបង្កើតឯកសារបានទេ: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
    refNumberController.dispose();
    dateController.dispose();
    taskController.dispose();
    programController.dispose();
    super.dispose();
  }

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
              child: const Row(
                children: [
                  Text(
                    "បង្កើតឯកសារ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        label: "ចំណងជើង",
                        controller: titleController,
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: "ចំណងជើងឡាតាំង",
                        controller: subTitleController,
                      ),
                      const SizedBox(height: 16),

                      DropdownField(
                        label: "ប្រភេទឯកសារចូល",
                        value: _selectedCategory,
                        items: _categories,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: "លេខលិខិត",
                        controller: refNumberController,
                      ),
                      const SizedBox(height: 16),

                      DatePicker(
                        label: "កាលបរិច្ឆេទលិខិត",
                        controller: dateController,
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: "កម្មវត្ថុ",
                        controller: taskController,
                      ),
                      const SizedBox(height: 16),

                      TextFieldWidget(
                        label: "កម្មវិធី",
                        controller: programController,
                      ),
                      const SizedBox(height: 16),

                      UploadField(
                        label: "ឯកសារភ្ជាប់",
                        fileName: _attachmentName.isNotEmpty
                            ? _attachmentName
                            : "ជ្រើសរើសឯកសារ",
                        onTap: _pickFile,
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
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
                                child: const Text('លុបចោល',
                                    style: TextStyle(color: AppColors.grey)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ButtonWidget(
                              text: "បង្កើត",
                              isLoading: _isSubmitting,
                              onPressed: _isSubmitting ? null : _submit,
                            ),
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
