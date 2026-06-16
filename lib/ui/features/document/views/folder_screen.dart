import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/views/widgets/folder_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Full-screen view showing all folders for a specific [DocumentType].
/// Includes folders loaded from JSON + any newly created folders.
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
            child: Obx(() {
              final isLoading = _controller.isLoading.value;
              final error = _controller.error.value;
              final folders = _controller.folders;

              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

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
                          onPressed: () => _controller.loadFolders(),
                          child: const Text('ព្យាយាមម្តងទៀត'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (folders.isEmpty) {
                return const Center(
                  child: Text(
                    'មិនទាន់មានថតឯកសារ',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                );
              }

              // Delegate the grid to FolderContent — it handles the full
              // folder list UI + header (filter + create) internally.
              return FolderContent(
                type: widget.type,
                onFolderTap: (_) {},
              );
            }),
          ),
        ],
      ),
    );
  }
}
