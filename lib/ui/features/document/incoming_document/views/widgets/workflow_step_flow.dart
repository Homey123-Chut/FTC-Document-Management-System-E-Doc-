import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/data/models/document/detail_document.dart';
import 'package:flutter/material.dart';

/// Horizontal workflow flow showing approval steps with status indicators.
/// Each step is a numbered circle connected by lines, color-coded by status.
class WorkflowStepFlow extends StatelessWidget {
  final DetailDocumentModel detail;
  final List<ApprovalStepModel> steps;

  const WorkflowStepFlow({
    super.key,
    required this.detail,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromARGB(255, 210, 209, 209)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_tree_outlined,
                  size: 20, color: AppColors.darkBlue),
              const SizedBox(width: 8),
              Text(
                detail.workflowName.isNotEmpty
                    ? detail.workflowName
                    : 'លំហូរឯកសារ',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${detail.totalSteps} ជំហាន',
                style: AppTextStyles.caption2,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (detail.workflowDescription.isNotEmpty) ...[
            Text(
              detail.workflowDescription,
              style: AppTextStyles.caption2.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
          ],
          if (steps.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text('មិនមានព័ត៌មានលំហូរ',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: steps.length,
                separatorBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _ConnectorLine(
                    completed: steps[__].isApproved || steps[__].isRejected,
                  ),
                ),
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return _StepCircle(
                    step: step,
                    isLast: index == steps.length - 1,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Step circle ──────────────────────────────────────────────────────────

class _StepCircle extends StatelessWidget {
  final ApprovalStepModel step;
  final bool isLast;

  const _StepCircle({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final Color circleColor;
    final IconData icon;
    final String label;

    if (step.isApproved) {
      circleColor = const Color(0xFF22C55E);
      icon = Icons.check;
      label = 'បានអនុម័ត';
    } else if (step.isRejected) {
      circleColor = const Color(0xFFDC2626);
      icon = Icons.close;
      label = 'បានបដិសេធ';
    } else {
      circleColor = const Color(0xFFF59E0B);
      icon = Icons.more_horiz;
      label = 'កំពុងរង់ចាំ';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: circleColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: circleColor, width: 2),
          ),
          child: Center(
            child: step.isApproved || step.isRejected
                ? Icon(icon, color: circleColor, size: 20)
                : Text(
                    '${step.stepNumber}',
                    style: TextStyle(
                      color: circleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          step.level.isNotEmpty ? step.level : 'ជំហាន ${step.stepNumber}',
          style: AppTextStyles.caption2.copyWith(fontSize: 10),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: circleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Connector line between steps ─────────────────────────────────────────

class _ConnectorLine extends StatelessWidget {
  final bool completed;
  const _ConnectorLine({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Container(
        width: 28,
        height: 3,
        decoration: BoxDecoration(
          color: completed ? const Color(0xFF22C55E) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
