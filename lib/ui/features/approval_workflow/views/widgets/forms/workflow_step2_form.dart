import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/workflow_approval_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/display/step_arrow_header.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_input_field.dart';
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
  late final WorkflowApprovalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<WorkflowApprovalController>();
  }

  @override
  void dispose() {
    _khmerTitleController.dispose();
    _latinTitleController.dispose();
    super.dispose();
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
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: widget.onBack,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            side: const BorderSide(color: AppColors.grey),
                          ),
                          child: const Text('បោះបង់',
                              style: TextStyle(color: AppColors.grey)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => ButtonWidget(
                          text: "បង្កើត",
                          isLoading: _controller.isCreatingWorkflow.value,
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            _controller.createWorkflow(
                              titleKhmer: _khmerTitleController.text.trim(),
                              titleLatin: _latinTitleController.text.trim(),
                              onSuccess: widget.onCreated,
                            );
                          },
                        ),
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
    return const StepArrowHeader(
      steps: [
        StepArrowData(title: 'ជំហានទី ១', isActive: false),
        StepArrowData(title: 'ជំហានទី ២', isActive: true),
      ],
    );
  }
}