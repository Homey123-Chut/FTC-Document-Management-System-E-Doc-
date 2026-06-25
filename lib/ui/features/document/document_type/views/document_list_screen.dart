import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/document_type/controllers/document_controller.dart';
import 'package:e_doc_redo/ui/features/document/folder/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/document_type/views/widgets/document_list_content.dart';
import 'package:e_doc_redo/ui/features/document/document_search/views/document_search_screen.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DocumentListScreen extends StatefulWidget {
  final DocumentType type;

  const DocumentListScreen({super.key, required this.type});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  late final DocumentController _docController;
  late final FolderController _folderController;

  @override
  void initState() {
    super.initState();

    _docController = Get.put(
      DocumentController(type: widget.type),
      tag: 'doc_${widget.type.name}',
    );
    _folderController = Get.put(
      FolderController(type: widget.type),
      tag: 'folder_${widget.type.name}',
    );
  }

  @override
  void dispose() {
    Get.delete<DocumentController>(tag: 'doc_${widget.type.name}');
    Get.delete<FolderController>(tag: 'folder_${widget.type.name}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          TopNavBarWidget(
            title: widget.type.khmerTitle,
            onBackTap: () => Get.back(),
            onSearchTap: () {
              Get.to(() => DocumentSearchScreen(type: widget.type));
            },
          ),
          Expanded(
            child: Obx(() {
              // Read all reactive values so Obx tracks every dependency
              final docLoading = _docController.isLoading.value;
              final docError = _docController.error.value;

              if (docLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (docError.isNotEmpty) {
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
                          'មានបញ្ហា: $docError',
                          style: AppTextStyles.body3,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _docController.loadDocuments(),
                          child: const Text('ព្យាយាមម្តងទៀត'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return DocumentListContent(
                type: widget.type,
                folderController: _folderController,
              );
            }),
          ),
        ],
      ),
    );
  }
}
