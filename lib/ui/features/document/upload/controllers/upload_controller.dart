import 'package:e_doc_redo/data/models/file/attached_file_info.dart';
import 'package:e_doc_redo/ui/features/document/upload/repositories_impl/upload_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/upload/services/upload_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

/// Reactive controller for file-upload workflows.
///
/// Manages the list of selected files, triggers file picking, validates
/// each file through [UploadService], and persists via the repository.
///
/// Usage:
/// ```dart
/// final uploadCtrl = Get.put(UploadController());
/// // In your widget:
/// UploadField(
///   label: 'ឯកសារភ្ជាប់',
///   files: uploadCtrl.files,
///   onTap: uploadCtrl.pickAndAddFile,
///   onRemove: uploadCtrl.removeFile,
/// )
class UploadController extends GetxController {
  final UploadService service;

  UploadController({
    UploadService? service,
  }) : service = service ??
            UploadService(repository: UploadRepositoryImpl());

  // ── Reactive state ────────────────────────────────────────────────────

  /// Currently selected files waiting to be uploaded.
  final files = <AttachedFileInfo>[].obs;

  /// Whether an upload is in progress.
  final isUploading = false.obs;

  /// The latest error message, or empty when no error.
  final error = ''.obs;

  /// Whether any files have been selected.
  bool get hasFiles => files.isNotEmpty;

  // ── File picking ──────────────────────────────────────────────────────

  /// Opens the native file picker.  When the user selects a file it is
  /// validated and added to [files] on success.
  Future<void> pickAndAddFile() async {
    error.value = '';

    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    final platformFile = result.files.first;

    final file = AttachedFileInfo(
      name: platformFile.name,
      path: platformFile.path,
      bytes: platformFile.bytes,
      size: platformFile.size,
      extension: platformFile.extension ?? '',
    );

    // Validate before adding
    final validationError = service.validate(file);
    if (validationError != null) {
      error.value = validationError;
      return;
    }

    files.add(file);
  }

  // ── Remove ────────────────────────────────────────────────────────────

  /// Removes the file at [index] from the selection list.
  void removeFile(int index) {
    if (index >= 0 && index < files.length) {
      files.removeAt(index);
    }
  }

  // ── Upload ────────────────────────────────────────────────────────────

  /// Uploads all files in [files] through the service.
  /// On success the file list is cleared.
  Future<void> uploadAll() async {
    if (files.isEmpty) return;

    isUploading.value = true;
    error.value = '';

    try {
      for (final file in files) {
        await service.upload(file);
      }
      files.clear();
      Get.snackbar(
        'ជោគជ័យ',
        'ឯកសារត្រូវបានបញ្ចូលដោយជោគជ័យ',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'មានបញ្ហា',
        'មិនអាចបញ្ចូលឯកសារបានទេ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
    }
  }
}
