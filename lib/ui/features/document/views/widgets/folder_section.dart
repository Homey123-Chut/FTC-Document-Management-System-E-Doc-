import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/string_extension.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/views/folder_screen.dart';
import 'package:e_doc_redo/ui/features/document/views/widgets/folder_card.dart';
import 'package:e_doc_redo/ui/features/document/views/widgets/forms/folder_create_form.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Displays the expandable folder section on the home screen.
///
/// Shows a limited preview of folders (up to [maxDisplayCount]) plus a
/// "Show More" card. Reads data from [FolderController] via Get.find()
/// inside Obx wrappers for instant reactive updates after create/delete.
class FolderSection extends StatelessWidget {
  final DocumentType type;
  final int maxDisplayCount;

  const FolderSection({
    super.key,
    required this.type,
    this.maxDisplayCount = 5,
  });

  void _openCreateFolderDialog(BuildContext context) {
    Get.dialog(
      FolderCreateForm(type: type),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'ថតដាក់ឯកសារ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            const Divider(
              height: 2,
              thickness: 1,
              color: Color(0xFFF1F3F5),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'រាយបញ្ជីរថត \n ដាក់ឯកសារ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  style: IconButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  fit: FlexFit.loose,
                  child: ButtonWidget(
                    text: 'បង្កើតសំណុំឯកសារ',
                    icon: Icons.add,
                    height: 42,
                    backgroundColor: AppColors.darkBlue,
                    onPressed: () => _openCreateFolderDialog(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),

            // ── FOLDER GRID (reactive via Obx) ──
            Obx(() {
              final folderCtrl = Get.find<FolderController>(
                  tag: 'folder_${type.name}');
              final allFolders = folderCtrl.folders;
              final displayed = allFolders.take(maxDisplayCount).toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: displayed.length + 1,
                itemBuilder: (context, index) {
                  if (index == displayed.length) {
                    return _buildShowMoreCard(context);
                  }
                  final folder = displayed[index];
                  return FolderCard(
                    title: folder.title.textWithDots(28),
                    documentCount: folder.documentCount,
                    onTap: () {},
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildShowMoreCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => FoldersScreen(type: type)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F3F5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.apps,
                color: Color(0xFF1565C0),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'បង្ហាញបន្ថែម',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3142),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
