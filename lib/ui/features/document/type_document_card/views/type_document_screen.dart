import 'package:e_doc_redo/ui/features/document/type_document_card/controllers/type_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/type_document_card/views/widget/type_document_content.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/theme.dart';

class TypeDocumentScreen extends StatefulWidget {
  const TypeDocumentScreen({super.key});

  @override
  State<TypeDocumentScreen> createState() => _TypeDocumentScreenState();
}

class _TypeDocumentScreenState extends State<TypeDocumentScreen> {
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<TypeDocumentController>()) {
      Get.delete<TypeDocumentController>();
    }
    Get.put(TypeDocumentController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<TypeDocumentController>()) {
      Get.delete<TypeDocumentController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TypeDocumentController>();

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
