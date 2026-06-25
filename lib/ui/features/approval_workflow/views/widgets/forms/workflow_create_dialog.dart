import 'package:e_doc_redo/ui/features/approval_workflow/views/widgets/forms/workflow_step1_form.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/views/widgets/forms/workflow_step2_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkflowCreateDialog extends StatefulWidget {
  const WorkflowCreateDialog({super.key});

  @override
  State<WorkflowCreateDialog> createState() => _WorkflowCreateDialogState();
}

class _WorkflowCreateDialogState extends State<WorkflowCreateDialog> {
  int _currentStep = 0; // 0 = step 1, 1 = step 2

  void _goToStep2() => setState(() => _currentStep = 1);
  void _goToStep1() => setState(() => _currentStep = 0);
  void _close() => Get.back(); // close the dialog

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _currentStep == 0
              ? WorkflowStep1Form(
                  onContinue: _goToStep2,
                  onCancel: _close,
                )
              : ApprovalWorkflowStep2Form(
                  onBack: _goToStep1,
                  onCreated: _close,
                ),
        ),
      ),
    );
  }
}
