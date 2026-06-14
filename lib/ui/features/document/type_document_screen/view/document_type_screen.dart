import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/controllers/document_controller.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/controllers/folder_controller.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/view/widgets/document_type_content.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen displaying documents filtered by [DocumentType].
/// Uses [DocumentController] and [FolderController] for reactive state management.
class DocumentTypeScreen extends StatefulWidget {
  final DocumentType type;

  const DocumentTypeScreen({super.key, required this.type});

  @override
  State<DocumentTypeScreen> createState() => _DocumentTypeScreenState();
}

class _DocumentTypeScreenState extends State<DocumentTypeScreen> {
  late final DocumentController _docController;

  @override
  void initState() {
    super.initState();
    // Put controllers into GetX dependency injection so child widgets
    // and forms can find them via Get.find().
    _docController = Get.put(
      DocumentController(type: widget.type),
      tag: 'doc_${widget.type.name}',
    );
    Get.put(
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
              // TODO: Navigate to search screen
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

              return DocumentTypeContent(
                type: widget.type,
              );
            }),
          ),
        ],
      ),
    );
  }
}
