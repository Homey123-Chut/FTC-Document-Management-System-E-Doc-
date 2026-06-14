import 'package:e_doc_redo/data/models/document/folder.dart';
import 'package:e_doc_redo/data/repositories/document/folder_repository.dart';

/// Pure Dart service — no GetX dependency.
/// Wraps [FolderRepository] for folder-related business logic.
class FolderService {
  final FolderRepository repository;

  FolderService({required this.repository});

  Future<List<FolderModel>> getFolders() async {
    return repository.getFolders();
  }

  Future<List<FolderModel>> getFoldersByType(String type) async {
    return repository.getFoldersByType(type);
  }

  Future<FolderModel> getFolderById(String id) async {
    return repository.getFolderById(id);
  }

  Future<void> createFolder(FolderModel folder, String type) async {
    return repository.addFolder(folder, type);
  }
}
