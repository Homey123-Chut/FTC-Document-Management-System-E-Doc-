import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/approval_workflow_search_controller.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:e_doc_redo/ui/widgets/search/search_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalWorkflowSearchScreen
    extends GetView<ApprovalWorkflowSearchController> {
  const ApprovalWorkflowSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: SearchContent<ApprovalWorkflowModel>(
                searchCtrl: controller.searchCtrl,
                searchQuery: controller.searchQuery,
                isLoading: controller.isLoading,
                searchResults: controller.searchResults,
                onSearchChanged: controller.onSearchChanged,
                onClear: controller.clearSearch,
                searchHint: 'ស្វែងរក',
                noResultTitle: 'រកមិនឃើញលំហូរឯកសារ',
                noResultSubtitle: 'សូមព្យាយាមប្រើពាក្យគន្លឹះផ្សេង',
                buildResultItem: (w) => _WorkflowResultCard(workflow: w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkflowResultCard extends StatelessWidget {
  final ApprovalWorkflowModel workflow;

  const _WorkflowResultCard({required this.workflow});

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.darkBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.account_tree_outlined,
                color: AppColors.darkBlue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  workflow.workflowTitleKhmer,
                  style: AppTextStyles.subtitle3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  workflow.workflowTitleLatin,
                  style: AppTextStyles.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${workflow.totalLevels} ជាន់  •  ${workflow.totalDocuments} ឯកសារ',
                  style: AppTextStyles.caption2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              workflow.documentType,
              style: AppTextStyles.caption2.copyWith(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
