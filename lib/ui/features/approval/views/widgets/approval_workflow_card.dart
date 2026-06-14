


import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:flutter/material.dart';

class ApprovalWorkflowCard extends StatelessWidget {
  final ApprovalWorkflowModel workflow;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ApprovalWorkflowCard({
    super.key,
    required this.workflow,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = '${workflow.createdAt.year}-${workflow.createdAt.month.toString().padLeft(2, '0')}-${workflow.createdAt.day.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color.fromARGB(255, 187, 186, 186)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflow.workflowTitleKhmer,
                      style: AppTextStyles.title3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workflow.workflowTitleLatin,
                      style: AppTextStyles.label2,
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      "សកម្ម",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          if (workflow.description.isNotEmpty) ...[
            Text(
              workflow.description,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
          ],

          // Metadata Row
          Text(
            'អត្តសញ្ញាណ: ${workflow.id}  •  ឯកសារ ${workflow.totalDocuments}  •  កម្រិត ${workflow.totalLevels}  •  $dateStr',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const Divider(height: 32, thickness: 1, color: Color(0xFFF0F0F0)),

          // Footer: Steps Breadcrumb + Actions
          Row(
            children: [
              Expanded(
                child: Text(
                  workflow.steps.map((s) => s.level).join(' > '),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Edit Button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, color: AppColors.darkBlue),
                ),
              ),
              const SizedBox(width: 8),
              // Delete Button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.darkRed),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}