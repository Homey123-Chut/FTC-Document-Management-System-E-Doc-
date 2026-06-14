import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/widgets/detail_document_content.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Detail screen for a sent outgoing document.
/// Uses [GetView] — the controller is registered in the route definition.
class DetailDocumentScreen extends GetView<DocumentDetailController> {
  const DetailDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            TopNavBarWidget(
              title: 'ព័ត៌មានលម្អិត',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: DetailDocumentContent(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
