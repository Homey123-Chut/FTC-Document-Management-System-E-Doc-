import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/data/models/document/type_document.dart';
import 'package:e_doc_redo/ui/features/document/type_document_card/controllers/type_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_document_type_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/theme.dart';

/// Pure UI body of the TypeDocument screen.
/// Receives [controller] for reactive state.
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

      // Only show the 4 main document types
      final list = (state.data ?? [])
          .where((d) => ['personal', 'incoming', 'outgoing', 'general'].contains(d.type))
          .toList();

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
            Expanded(
              child: _buildGrid(list),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGrid(List<TypeDocumentModel> list) {
    final colorMap = <String, Color>{
      'personal': AppColors.lightBlue,
      'incoming': AppColors.green,
      'outgoing': AppColors.darkBlue,
      'general': AppColors.blue,
      'workflow': AppColors.yellow,
      'department': AppColors.red,
    };

    final iconMap = <String, IconData>{
      'personal': Icons.person_outline,
      'incoming': Icons.move_to_inbox_outlined,
      'outgoing': Icons.send_outlined,
      'general': Icons.description_outlined,
      'workflow': Icons.account_tree_outlined,
      'department': Icons.business_outlined,
    };

    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      children: list.map((doc) {
        return EdocDocumentTypeCard(
          icon: iconMap[doc.type] ?? Icons.folder_outlined,
          title: doc.title,
          count: doc.totalDocs,
          backgroundColor: colorMap[doc.type] ?? AppColors.blue,
        );
      }).toList(),
    );
  }
}
