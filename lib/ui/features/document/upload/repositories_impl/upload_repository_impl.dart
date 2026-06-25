import 'dart:math';

import 'package:e_doc_redo/data/models/file/attached_file_info.dart';
import 'package:e_doc_redo/data/repositories/file/upload_repository.dart';

/// Mock implementation of [UploadRepository] for development and testing.
/// Simulates network delay and returns a fake storage identifier.
class UploadRepositoryImpl implements UploadRepository {
  final _random = Random();

  @override
  Future<String> uploadFile(AttachedFileInfo file) async {
    // Simulate network latency (300–800 ms)
    await Future.delayed(
      Duration(milliseconds: 300 + _random.nextInt(500)),
    );

    // Return a fake storage path
    return '/uploads/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
  }

  @override
  Future<void> removeFile(String fileId) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
