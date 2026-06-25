import 'package:e_doc_redo/core/utils/string_extension.dart';
import 'package:e_doc_redo/ui/features/document/folder/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/folder/views/widgets/folder_card.dart';
import 'package:e_doc_redo/ui/features/document/document_type/views/widgets/show_more_folder_card.dart';
import 'package:e_doc_redo/ui/widgets/display/header_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FolderSection extends StatelessWidget {
  final FolderController controller;
  final int maxDisplayCount;

  const FolderSection({
    super.key,
    required this.controller,
    this.maxDisplayCount = 5,
  });

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
              color: Colors.blueGrey,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
          children: [
            const Divider(height: 2, thickness: 1, color: Color(0xFFF1F3F5)),
            const SizedBox(height: 16),
            HeaderFolderSection(
              onCreateFolder: controller.openCreateFolderDialog,
            ),
            const SizedBox(height: 2),

            // ── Folder grid (reactive) ──
            Obx(() {
              final allFolders = controller.folders;
              final displayed = allFolders.take(maxDisplayCount).toList();

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
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
                    return ShowMoreFolderCard(
                      onTap: controller.navigateToAllFolders,
                    );
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
}
