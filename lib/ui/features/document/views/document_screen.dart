import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/async_value.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/views/document_type_screen.dart';
import 'package:e_doc_redo/ui/features/home/controllers/home_type_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_document_type_card.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Entry screen showing 4 document-type cards in a 2×2 grid.
/// Each card shows the total document count per type (fetched via [HomeTypeDocumentController])
/// and navigates to [DocumentTypeScreen] with the corresponding [DocumentType].
class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  static const _types = [
    DocumentType.personal,
    DocumentType.general,
    DocumentType.incoming,
    DocumentType.outgoing,
  ];

  late final HomeTypeDocumentController _typeController;

  @override
  void initState() {
    super.initState();
    // Register the controller if not already registered by HomeScreen.
    if (!Get.isRegistered<HomeTypeDocumentController>()) {
      Get.put(HomeTypeDocumentController());
    }
    _typeController = Get.find<HomeTypeDocumentController>();
  }

  int _countForType(DocumentType type) {
    final docs = _typeController.documents;
    final match = docs.where((d) => d.type == type.name).firstOrNull;
    return match?.totalDocs ?? 0;
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
                    Text(
                      'ប្រភេទឯកសារ',
                      style: AppTextStyles.title2,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(() {
                        final state = _typeController.typeData.value;
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
                              count:
                                  isLoading ? 0 : _countForType(type),
                              backgroundColor: type.color,
                              onTap: () => Get.to(
                                () => DocumentTypeScreen(type: type),
                              ),
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
