import 'package:e_doc_redo/core/utils/file_extension.dart';
import 'package:e_doc_redo/data/models/file/attached_file_info.dart';
import 'package:e_doc_redo/data/repositories/file/upload_repository.dart';

/// Pure business-logic service for file-upload operations.
/// Handles validation and coordinates with [UploadRepository] for persistence.
class UploadService {
  final UploadRepository repository;

  /// Maximum allowed file size in bytes (default 50 MB).
  final int maxFileSize;

  /// Allowed file extensions (lowercase, without dot).
  /// When empty all extensions are allowed.
  final List<String> allowedExtensions;

  UploadService({
    required this.repository,
    this.maxFileSize = 50 * 1024 * 1024, // 50 MB
    this.allowedExtensions = const [],
  });

  // ── Validation ────────────────────────────────────────────────────────

  /// Validates [file] against configured size and extension constraints.
  /// Returns `null` when the file is valid, otherwise a Khmer error message.
  String? validate(AttachedFileInfo file) {
    if (file.size > maxFileSize) {
      return 'ឯកសារធំពេក។ ទំហំអតិបរមា៖ ${FileExtension.formatSize(maxFileSize)}';
    }

    if (allowedExtensions.isNotEmpty) {
      final ext = file.extension.toLowerCase();
      if (!allowedExtensions.contains(ext)) {
        return 'ប្រភេទឯកសារមិនត្រូវបានអនុញ្ញាត៖ .$ext';
      }
    }

    return null; // valid
  }

  /// Returns `true` when [file] passes all validation rules.
  bool isValid(AttachedFileInfo file) => validate(file) == null;

  // ── Upload ────────────────────────────────────────────────────────────

  /// Uploads [file] through the repository.
  /// Returns the storage identifier on success.
  Future<String> upload(AttachedFileInfo file) async {
    return repository.uploadFile(file);
  }

  /// Removes a previously uploaded file by [fileId].
  Future<void> remove(String fileId) async {
    return repository.removeFile(fileId);
  }
}
