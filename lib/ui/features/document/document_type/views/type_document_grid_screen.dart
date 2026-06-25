import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/document_type/controllers/type_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/document_type/views/widgets/type_document_grid_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TypeDocumentScreen extends GetView<TypeDocumentController> {
  const TypeDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const TopBarWidget(),
            Expanded(
              child: TypeDocumentContent(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
