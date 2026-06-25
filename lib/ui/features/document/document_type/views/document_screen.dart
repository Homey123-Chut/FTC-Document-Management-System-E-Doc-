import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/home/controllers/home_type_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_document_type_card.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentScreen extends GetView<HomeTypeDocumentController> {
  static const _types = [
    DocumentType.personal,
    DocumentType.incoming,
    DocumentType.outgoing,
    DocumentType.general,
  ];

  const DocumentScreen({super.key});

  int _countForType(DocumentType type) {
    final docs = controller.documents;
    final match = docs.where((d) => d.type == type.name).firstOrNull;
    return match?.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const TopBarWidget(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('ប្រភេទឯកសារ', style: AppTextStyles.title2),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(() {
                        final state = controller.typeData.value;
                        final isLoading =
                            state.state == AsyncValueState.loading;

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _types.length,
                          itemBuilder: (context, index) {
                            final type = _types[index];
                            return EdocDocumentTypeCard(
                              icon: type.icon,
                              title: type.khmerTitle,
                              count: isLoading ? 0 : _countForType(type),
                              backgroundColor: type.color,
                              onTap: () => type.navigate(),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
