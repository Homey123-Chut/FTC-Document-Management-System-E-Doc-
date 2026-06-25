import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/folder.dart';
import 'package:e_doc_redo/ui/features/document/folder/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/folder/views/widgets/folder_card.dart';
import 'package:e_doc_redo/ui/widgets/display/header_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Full folder list content — handles every state (loading / error / empty /
/// data) inside a single [Obx] so there is no nesting conflict with parent
/// screens.
class FolderContent extends StatelessWidget {
  final FolderController controller;
  final void Function(FolderModel folder)? onFolderTap;

  const FolderContent({
    super.key,
    required this.controller,
    this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final error = controller.error.value;
      final folders = controller.folders;

      // ── Loading ────────────────────────────────────────────────────
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      // ── Error ──────────────────────────────────────────────────────
      if (error.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  'មានបញ្ហា: $error',
                  style: AppTextStyles.body3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadFolders(),
                  child: const Text('ព្យាយាមម្តងទៀត'),
                ),
              ],
            ),
          ),
        );
      }

      // ── Empty ──────────────────────────────────────────────────────
      if (folders.isEmpty) {
        return Center(
          child: Text(
            'មិនទាន់មានថតឯកសារ',
            style: AppTextStyles.body2,
          ),
        );
      }

      // ── Data ───────────────────────────────────────────────────────
      return Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              border:
                  Border.all(color: AppColors.backgroundGrey, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  HeaderFolderSection(
                    onCreateFolder: controller.openCreateFolderDialog,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 2, bottom: 20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: folders.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.15,
                      ),
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        return FolderCard(
                          title: folder.title,
                          documentCount: folder.documentCount,
                          onTap: () => onFolderTap?.call(folder),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
