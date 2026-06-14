import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/ui/features/approval/controllers/workflow_approval_controller.dart';
import 'package:e_doc_redo/ui/widgets/action/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/input/edoc_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalWorkflowStep2Form extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onCreated;

  const ApprovalWorkflowStep2Form({
    super.key,
    required this.onBack,
    required this.onCreated,
  });

  @override
  State<ApprovalWorkflowStep2Form> createState() =>
      _ApprovalWorkflowStep2FormState();
}

class _ApprovalWorkflowStep2FormState extends State<ApprovalWorkflowStep2Form> {
  final _formKey = GlobalKey<FormState>();
  final _khmerTitleController = TextEditingController();
  final _latinTitleController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _khmerTitleController.dispose();
    _latinTitleController.dispose();
    super.dispose();
  }

  Future<void> _createWorkflow() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final controller = Get.find<WorkflowApprovalController>();
    final workflow = ApprovalWorkflowModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workflowTitleKhmer: _khmerTitleController.text.trim(),
      workflowTitleLatin: _latinTitleController.text.trim(),
      description: '',
      documentType: controller.selectedDocumentType.value,
      totalDocuments: 0,
      totalLevels: controller.approvalSteps.length,
      createdAt: DateTime.now(),
      steps: List<ApprovalStepModel>.from(controller.approvalSteps),
    );

    await controller.createWorkflow(workflow);
    setState(() => _isSubmitting = false);

    widget.onCreated();
    Get.snackbar('ជោគជ័យ', 'លំហូរឯកសារត្រូវបានបង្កើត');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Blue Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: const Text(
            "បង្កើតលំហូរឯកសារ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Scrollable Form Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStepHeader(),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        label: "ចំណងជើង",
                        hintText: "សូមសរសេរចំណងជើង",
                        controller: _khmerTitleController,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        label: "ចំណងជើងឡាតាំង",
                        hintText: "សូមសរសេរចំណងជើង",
                        controller: _latinTitleController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: "បោះបង់",
                        backgroundColor: const Color(0xFFF5F5F5),
                        foregroundColor: Colors.black,
                        onPressed: widget.onBack,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ButtonWidget(
                        text: "បង្កើត",
                        isLoading: _isSubmitting,
                        onPressed: _createWorkflow,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepHeader() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ClipPath(
              clipper: ArrowClipper(isLast: false),
              child: Container(
                color: const Color(0xFFE8EAF6),
                alignment: Alignment.center,
                child: Text(
                  "ជំហានទី ១",
                  style: AppTextStyles.label2.copyWith(color: AppColors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipPath(
              clipper: ArrowClipper(isLast: true),
              child: Container(
                color: AppColors.darkBlue,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "ជំហានទី ២",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  final bool isLast;
  ArrowClipper({required this.isLast});

  @override
  Path getClip(Size size) {
    final path = Path();
    double startX = isLast ? 15.0 : 0.0;

    path.moveTo(startX, 0);
    path.lineTo(size.width - 15, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 15, size.height);
    path.lineTo(startX, size.height);

    if (isLast) {
      path.lineTo(startX + 15, size.height / 2);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}