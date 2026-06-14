import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/approval/views/workflow_approval_screen.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/view/document_type_screen.dart';
import 'package:e_doc_redo/ui/features/home/controllers/total_document_controller.dart';
import 'package:e_doc_redo/ui/features/home/controllers/type_document_controller.dart' as home_ctrl;
import 'package:e_doc_redo/ui/features/home/view/widgets/home_content.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(TotalDocumentController());
    Get.put(home_ctrl.HomeTypeDocumentController());
  }

  void _navigateToDocuments(String type) {
    if (type == 'workflow') {
      Get.to(() => const WorkflowApprovalScreen());
      return;
    }
    final docType = DocumentTypeX.fromString(type);
    Get.to(() => DocumentTypeScreen(type: docType));
  }

  @override
  Widget build(BuildContext context) {
    final totalController = Get.find<TotalDocumentController>();
    final typeController = Get.find<home_ctrl.HomeTypeDocumentController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TopBarWidget(),
            Expanded(
              child: Obx(() {
                final totalState = totalController.totalData.value;
                final typeState = typeController.typeData.value;

                if (totalState.state == AsyncValueState.loading ||
                    typeState.state == AsyncValueState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (totalState.state == AsyncValueState.error) {
                  return Center(
                    child: Text('Error: ${totalState.error}'),
                  );
                }
                if (typeState.state == AsyncValueState.error) {
                  return Center(
                    child: Text('Error: ${typeState.error}'),
                  );
                }
                return HomeContent(
                  totals: totalController.data,
                  typeDocuments: typeController.documents,
                  onNavigateToDocuments: _navigateToDocuments,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
