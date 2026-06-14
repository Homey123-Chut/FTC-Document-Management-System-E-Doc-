import 'package:e_doc_redo/data/models/document/folder.dart';

abstract class FolderRepository {
  Future<List<FolderModel>> getFolders();
  Future<List<FolderModel>> getFoldersByType(String type);
  Future<FolderModel> getFolderById(String id);
  Future<void> addFolder(FolderModel folder, String type);
  Future<void> updateFolder(FolderModel folder);
}
