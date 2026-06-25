import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/ui/features/document/document_type/controllers/document_controller.dart';
import 'package:e_doc_redo/ui/features/document/document_type/services/create_document_service.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_upload_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for the document-creation form.
///
/// Owns all mutable form state (text fields, file list, category, loading)
/// and every action (`pickFile`, `removeFile`, `previewFile`, `submit`).
/// Registered per-dialog via `Get.put()` so the form widget stays pure UI.
class CreateDocumentController extends GetxController {
  final CreateDocumentService service;
  final DocumentType type;

  CreateDocumentController({
    required this.type,
    CreateDocumentService? service,
  }) : service = service ?? CreateDocumentService(),
       selectedCategory = type.khmerTitle.obs;

  // ── Text controllers ────────────────────────────────────────────────

  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final refNumberController = TextEditingController();
  final dateController = TextEditingController();
  final taskController = TextEditingController();
  final programController = TextEditingController();

  // ── Reactive state ───────────────────────────────────────────────────

  final isSubmitting = false.obs;
  final attachedFiles = <AttachedFileInfo>[].obs;
  final RxString selectedCategory;

  // ── Derived ──────────────────────────────────────────────────────────

  /// Only real document categories (excludes workflow / department).
  List<String> get categories =>
      DocumentTypeX.documentCategories.map((t) => t.khmerTitle).toList();

  DocumentType get selectedType => DocumentType.values.firstWhere(
        (t) => t.khmerTitle == selectedCategory.value,
        orElse: () => type,
      );

  // ── Lifecycle ────────────────────────────────────────────────────────

  @override
  void onClose() {
    titleController.dispose();
    subTitleController.dispose();
    refNumberController.dispose();
    dateController.dispose();
    taskController.dispose();
    programController.dispose();
    super.onClose();
  }

  // ── Actions ──────────────────────────────────────────────────────────

  void setCategory(String? val) {
    if (val != null) selectedCategory.value = val;
  }

  /// Returns the tag of the [DocumentController] that was already updated
  /// by [CreateDocumentService.createDocument] via `ctrl.createDocument(doc)`.
  ///
  /// That call inserted the new document at index 0 and persisted through
  /// the repository, so this controller does **not** need a full reload.
  String get _alreadyUpdatedTag {
    final selectedTag = 'doc_${selectedType.name}';
    if (Get.isRegistered(tag: selectedTag)) return selectedTag;
    return 'doc_${type.name}';
  }

  /// Refreshes document-list controllers that were **not** already updated
  /// by the create flow, so the new document appears everywhere it should.
  void _refreshSourceController() {
    final skipTag = _alreadyUpdatedTag;

    // Refresh the selected-type controller (unless already updated)
    _refreshIfNotSkipped('doc_${selectedType.name}', skipTag);

    // Refresh the widget's own type controller if different
    if (selectedType.name != type.name) {
      _refreshIfNotSkipped('doc_${type.name}', skipTag);
    }

    // Always refresh the incoming controller so the recently-created
    // section picks up the new document
    _refreshIfNotSkipped('doc_incoming', skipTag);
  }

  /// Calls [DocumentController.loadDocuments] (and [loadRecentDocuments]
  /// on incoming) for the controller registered under [tag], unless [tag]
  /// matches [skipTag].
  void _refreshIfNotSkipped(String tag, String skipTag) {
    if (tag == skipTag) return;
    try {
      if (!Get.isRegistered(tag: tag)) return;
      final ctrl = Get.find<DocumentController>(tag: tag);
      ctrl.loadDocuments();
      if (tag == 'doc_incoming') {
        ctrl.loadRecentDocuments();
      }
    } catch (_) {
      // Controller not registered or refresh failed – non-critical
    }
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        for (final file in result.files) {
          final alreadyExists =
              attachedFiles.any((f) => f.name == file.name);
          if (!alreadyExists) {
            attachedFiles.add(AttachedFileInfo(
              name: file.name,
              path: file.path,
              bytes: file.bytes,
              size: file.size,
              extension: file.extension ?? '',
            ));
          }
        }
      }
    } catch (_) {
      Get.snackbar(
        'មានបញ្ហា',
        'មិនអាចជ្រើសរើសឯកសារបានទេ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeFile(int index) {
    attachedFiles.removeAt(index);
  }

  void previewFile(BuildContext context, int index) {
    final file = attachedFiles[index];
    showFilePreview(context, file);
  }

  Future<void> submit(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;

    try {
      final now = DateTime.now();
      final newDoc = DocumentModel(
        id: now.millisecondsSinceEpoch,
        titleKhmer: titleController.text.trim(),
        titleLatin: subTitleController.text.trim(),
        documentNumber: refNumberController.text.trim(),
        date: dateController.text.trim(),
        status: 'ពង្រៀង', // draft – recently created, not yet sent
        subject: taskController.text.trim(),
        program: programController.text.trim(),
        documentHistory: 'បានបង្កើតថ្មី',
        attachedFile: attachedFiles.map((f) => f.name).join(','),
        createdDate: now.toIso8601String(),
      );

      await service.createDocument(
        doc: newDoc,
        selectedTypeName: selectedType.name,
        widgetTypeName: type.name,
      );

      // Refresh the source list controller so the new card appears
      _refreshSourceController();

      Get.back();
      Get.snackbar(
        'ជោគជ័យ',
        'ឯកសារត្រូវបានបង្កើតដោយជោគជ័យ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'មានបញ្ហា',
        'មិនអាចបង្កើតឯកសារបានទេ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
