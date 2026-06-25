import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/document_search/controllers/document_search_controller.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:e_doc_redo/ui/widgets/search/search_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentSearchScreen extends StatelessWidget {
  final DocumentType type;

  const DocumentSearchScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DocumentSearchController(type: type));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            TopNavBarWidget(
              title: '',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SearchContent<DocumentModel>(
                searchCtrl: ctrl.searchCtrl,
                searchQuery: ctrl.searchQuery,
                isLoading: ctrl.isLoading,
                searchResults: ctrl.searchResults,
                onSearchChanged: ctrl.onSearchChanged,
                onClear: ctrl.clearSearch,
                searchHint: 'ស្វែងរក',
                noResultTitle: 'រកមិនឃើញឯកសារ',
                noResultSubtitle: 'សូមព្យាយាមប្រើពាក្យគន្លឹះផ្សេង',
                buildResultItem: (doc) =>
                    _DocumentResultCard(document: doc, type: type),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentResultCard extends StatelessWidget {
  final DocumentModel document;
  final DocumentType type;

  const _DocumentResultCard({required this.document, required this.type});

  @override
  Widget build(BuildContext context) {
    final docStatus = DocumentStatusX.fromString(document.status);
    final colors = docStatus.colors;
    final status = document.status.isNotEmpty ? document.status : 'មិនស្គាល់';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading — file icon in colored circle
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: type.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(type.icon, color: type.color, size: 22),
          ),
          const SizedBox(width: 14),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  document.titleKhmer.isNotEmpty
                      ? document.titleKhmer
                      : document.titleLatin,
                  style: AppTextStyles.subtitle3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (document.titleLatin.isNotEmpty &&
                    document.titleKhmer.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    document.titleLatin,
                    style: AppTextStyles.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'ល.រ ${document.documentNumber}  •  ${type.khmerTitle}  •  ${document.date}',
                  style: AppTextStyles.caption2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Trailing — status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors['bg'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: AppTextStyles.caption2.copyWith(
                color: colors['text'],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
