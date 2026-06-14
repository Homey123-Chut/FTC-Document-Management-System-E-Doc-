import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/controllers/document_search_controller.dart';
import 'package:e_doc_redo/ui/widgets/action/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_top_nav_bar.dart';
import 'package:e_doc_redo/ui/widgets/input/edoc_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable search screen scoped to a specific [DocumentType].
/// The user can search by document number, title (Khmer or Latin), or both.
class DocumentSearchScreen extends StatefulWidget {
  final DocumentType type;

  const DocumentSearchScreen({super.key, required this.type});

  @override
  State<DocumentSearchScreen> createState() => _DocumentSearchScreenState();
}

class _DocumentSearchScreenState extends State<DocumentSearchScreen> {
  DocumentSearchController get _controller =>
      Get.find<DocumentSearchController>();

  @override
  void initState() {
    super.initState();
    Get.put(DocumentSearchController(type: widget.type));
  }

  @override
  void dispose() {
    if (Get.isRegistered<DocumentSearchController>()) {
      Get.delete<DocumentSearchController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            TopNavBarWidget(
              title: 'ស្វែងរក ${widget.type.khmerTitle}',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      label: 'លេខឯកសារ',
                      controller: _controller.documentNumberCtrl,
                      hintText: 'ស្វែងរកតាមលេខឯកសារ...',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextFieldWidget(
                      label: 'ចំណងជើង',
                      controller: _controller.titleCtrl,
                      hintText: 'ស្វែងរកតាមចំណងជើង (ខ្មែរ ឬ ឡាតាំង)...',
                      textInputAction: TextInputAction.search,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            text: 'ស្វែងរក',
                            onPressed: _controller.performSearch,
                            isLoading: _controller.isLoading.value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ButtonWidget(
                            text: 'សម្អាត',
                            onPressed: _controller.clearSearch,
                            backgroundColor: Colors.grey[200],
                            foregroundColor: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() => _buildResultsArea()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_controller.isLoading.value) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller.error.value.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          _controller.error.value,
          style: AppTextStyles.body1.copyWith(color: AppColors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_controller.hasSearched.value) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.search, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'បញ្ចូលលេខឯកសារ ឬចំណងជើងដើម្បីស្វែងរក',
              style: AppTextStyles.caption1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_controller.searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'រកមិនឃើញឯកសារ',
              style: AppTextStyles.subtitle2.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'សូមព្យាយាមស្វែងរកដោយប្រើពាក្យគន្លឹះផ្សេង',
              style: AppTextStyles.caption2,
            ),
          ],
        ),
      );
    }

    final count = _controller.searchResults.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('រកឃើញ $count ឯកសារ', style: AppTextStyles.body3),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: count,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = _controller.searchResults[index];
            return _SearchResultItem(document: doc, type: widget.type);
          },
        ),
      ],
    );
  }
}

/// A single search result row matching the list item style.
class _SearchResultItem extends StatelessWidget {
  final DocumentModel document;
  final DocumentType type;

  const _SearchResultItem({required this.document, required this.type});

  Color _statusColor() {
    switch (document.status) {
      case 'បានអនុម័ត':
        return AppColors.green;
      case 'បានបដិសេធ':
        return AppColors.red;
      case 'កំពុងរង់ចាំ':
        return AppColors.yellow;
      default:
        return AppColors.grey;
    }
  }

  Color _statusBackgroundColor() {
    switch (document.status) {
      case 'បានអនុម័ត':
        return AppColors.backgroundGreen;
      case 'បានបដិសេធ':
        return AppColors.backgroundRed;
      case 'កំពុងរង់ចាំ':
        return AppColors.backgroundYellow;
      default:
        return AppColors.backgroundGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 56,
            decoration: BoxDecoration(
              color: type.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.titleKhmer,
                  style: AppTextStyles.subtitle3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.insert_drive_file_outlined,
                        size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'ល.រ ${document.documentNumber}  •  ${document.date}',
                        style: AppTextStyles.caption2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              document.status,
              style: AppTextStyles.caption2.copyWith(
                color: _statusColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
