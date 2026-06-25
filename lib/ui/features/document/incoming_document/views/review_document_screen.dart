import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/features/document/incoming_document/views/widgets/review_document_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailIncomingDocumentScreen
    extends GetView<DocumentDetailController> {
  const DetailIncomingDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final doc = controller.detail.value?.document;

              return TopNavBarWidget(
                title: doc?.titleKhmer ?? 'ព័ត៌មានលម្អិត',
                onBackTap: Get.back,
              );
            }),

            Expanded(
              child: DetailIncomingDocumentContent(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}