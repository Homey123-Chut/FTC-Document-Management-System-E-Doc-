import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/data/models/document/folder.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/repositories_impl/folder_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/services/folder_service.dart';
import 'package:get/get.dart';

/// GetX controller managing folders for a specific [DocumentType].
/// Uses [FolderService] → [FolderRepositoryImpl] for data access.
/// Exposes reactive [folders] list for automatic UI updates via Obx.
class FolderController extends GetxController {
  final FolderService service;
  final DocumentType type;

  FolderController({
    required this.type,
    FolderService? service,
  }) : service = service ?? FolderService(repository: FolderRepositoryImpl());

  final folders = <FolderModel>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;

  bool get hasData => folders.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadFolders();
  }

  /// Loads folders filtered by the controller's [type].
  Future<void> loadFolders() async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await service.getFoldersByType(type.name);
      folders.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Creates a new folder, persists it, and inserts it directly into
  /// the reactive [folders] list for immediate UI update via Obx.
  Future<void> createFolder(FolderModel folder) async {
    // Insert immediately so the UI updates without waiting for reload
    folders.insert(0, folder);

    try {
      await service.createFolder(folder, type.name);
    } catch (e) {
      // Remove on failure
      folders.removeWhere((f) => f.id == folder.id);
      error.value = e.toString();
      rethrow;
    }
  }
}
