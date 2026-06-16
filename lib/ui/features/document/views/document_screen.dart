import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/views/document_type_screen.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_document_type_card.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Entry screen showing 4 document-type cards in a 2×2 grid.
/// Each card navigates to [DocumentTypeScreen] with the corresponding [DocumentType].
class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  static const _types = [
    DocumentType.personal,
    DocumentType.general,
    DocumentType.incoming,
    DocumentType.outgoing,
  ];

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
                    Text(
                      'ប្រភេទឯកសារ',
                      style: AppTextStyles.title2,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
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
                            count: 0,
                            backgroundColor: type.color,
                            onTap: () => Get.to(
                              () => DocumentTypeScreen(type: type),
                            ),
                          );
                        },
                      ),
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
