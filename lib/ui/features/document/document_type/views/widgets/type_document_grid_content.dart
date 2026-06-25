import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/ui/features/document/document_type/controllers/type_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/document_type/views/widgets/type_document_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/theme.dart';

class TypeDocumentContent extends StatelessWidget {
  final TypeDocumentController controller;

  const TypeDocumentContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.documentState.value;

      if (state.state == AsyncValueState.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.state == AsyncValueState.error) {
        return Center(child: Text('Error: ${state.error}'));
      }

      final list = state.data ?? [];

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'ប្រភេទឯកសារ',
              style: AppTextStyles.title2,
            ),
            const SizedBox(height: 16),
            TypeDocumentGrid(typeDocuments: list),
          ],
        ),
      );
    });
  }
}
