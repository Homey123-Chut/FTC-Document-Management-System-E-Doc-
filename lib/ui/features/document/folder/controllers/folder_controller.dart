import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/data/models/document/folder.dart';
import 'package:e_doc_redo/ui/features/document/folder/repositories_impl/folder_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/folder/services/folder_service.dart';
import 'package:e_doc_redo/ui/features/document/folder/views/folder_screen.dart';
import 'package:e_doc_redo/ui/features/document/folder/views/widgets/forms/folder_create_form.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
  final isCreating = false.obs;

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
    folders.insert(0, folder);

    try {
      await service.createFolder(folder, type.name);
    } catch (e) {
      folders.removeWhere((f) => f.id == folder.id);
      error.value = e.toString();
      rethrow;
    }
  }

  // ── Dialog / Navigation helpers ─────────────────────────────────────

  /// Opens the create-folder dialog.
  void openCreateFolderDialog() {
    Get.dialog(
      FolderCreateForm(controller: this),
      barrierDismissible: false,
    );
  }

  /// Navigates to the full folder list screen.
  void navigateToAllFolders() {
    Get.to(() => FoldersScreen(type: type));
  }

  /// Validates the form, builds a [FolderModel], persists it via [createFolder],
  /// and shows a snackbar on error or navigates back on success.
  Future<void> submitFolder(GlobalKey<FormState> formKey, String name) async {
    if (!formKey.currentState!.validate()) return;

    isCreating.value = true;

    try {
      final newFolder = FolderModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: name.trim(),
        documentCount: 0,
      );
      await createFolder(newFolder);
      Get.back();
    } catch (e) {
      Get.snackbar(
        'មានបញ្ហា',
        'មិនអាចបង្កើតសំណុំឯកសារបានទេ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCreating.value = false;
    }
  }
}
