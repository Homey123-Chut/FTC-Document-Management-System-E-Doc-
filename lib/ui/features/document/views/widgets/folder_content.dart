import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/data/models/document/folder.dart';
import 'package:e_doc_redo/ui/features/document/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/views/widgets/folder_card.dart';
import 'package:e_doc_redo/ui/features/document/views/widgets/forms/folder_create_form.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Full-screen folder grid widget that reads reactively from [FolderController].
///
/// Renders ALL folders for the given [type] in a scrollable grid with a
/// header row (filter button + create button). Used inside [FoldersScreen].
class FolderContent extends StatelessWidget {
  final DocumentType type;
  final void Function(FolderModel folder)? onFolderTap;

  const FolderContent({
    super.key,
    required this.type,
    this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller =
          Get.find<FolderController>(tag: 'folder_${type.name}');
      final folders = controller.folders;

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
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  Expanded(child: _buildGrid(folders)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'រាយបញ្ជីថតដាក់ឯកសារ',
            style: AppTextStyles.subtitle1,
          ),
        ),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, size: 20, color: AppColors.black),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          fit: FlexFit.loose,
          child: ButtonWidget(
            text: 'បង្កើតកញ្ចប់ឯកសារ',
            icon: Icons.add,
            height: 44,
            backgroundColor: const Color(0xFF004085),
            onPressed: () => Get.dialog(FolderCreateForm(type: type)),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<FolderModel> folders) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 2, bottom: 20), 
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: folders.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
