import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/folder/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/folder/views/widgets/folder_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Full-screen view showing all folders for a specific [DocumentType].
///
/// Responsible only for dependency injection (controller lookup /
/// registration) and shell layout.  All state rendering (loading / error /
/// empty / data) lives in [FolderContent].
class FoldersScreen extends StatefulWidget {
  final DocumentType type;

  const FoldersScreen({super.key, required this.type});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  late final FolderController _controller;

  @override
  void initState() {
    super.initState();
    final tag = 'folder_${widget.type.name}';
    if (Get.isRegistered<FolderController>(tag: tag)) {
      _controller = Get.find<FolderController>(tag: tag);
    } else {
      _controller = Get.put(
        FolderController(type: widget.type),
        tag: tag,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          TopNavBarWidget(
            title: 'ថតដាក់ឯកសារ',
            onBackTap: () => Get.back(),
          ),
          Expanded(
            child: FolderContent(
              controller: _controller,
              onFolderTap: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
