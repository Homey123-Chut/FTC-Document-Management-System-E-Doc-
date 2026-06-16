import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/features/document/views/widgets/detail_document_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Detail screen for a sent outgoing document.
/// Uses [GetView] — the controller is registered in the route definition.
class DetailDocumentScreen extends GetView<DocumentDetailController> {
  const DetailDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final doc = controller.detail.value?.document;
              final title = doc != null && doc.titleKhmer.isNotEmpty
                  ? doc.titleKhmer
                  : 'ព័ត៌មានលម្អិត';
              return TopNavBarWidget(
                title: title,
                onBackTap: () => Get.back(),
              );
            }),
            Expanded(
              child: DetailDocumentContent(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
