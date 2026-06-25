import 'package:e_doc_redo/data/models/file/attached_file_info.dart';

/// Abstract contract for file-upload persistence.
/// Implementations may store files locally, upload to a remote server,
/// or use a mock backend.
abstract class UploadRepository {
  /// Uploads [file] to the storage backend.
  /// Returns the storage identifier or URL on success.
  Future<String> uploadFile(AttachedFileInfo file);

  /// Removes a previously uploaded file identified by [fileId].
  Future<void> removeFile(String fileId);
}
