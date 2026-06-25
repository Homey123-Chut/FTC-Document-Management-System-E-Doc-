

import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/level_workflow_controller.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/workflow_approval_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/display/step_arrow_header.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkflowStep1Form extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const WorkflowStep1Form({
    super.key,
    required this.onContinue,
    required this.onCancel,
  });

  @override
  State<WorkflowStep1Form> createState() => _WorkflowStep1FormState();
}

class _WorkflowStep1FormState extends State<WorkflowStep1Form> {
  late final WorkflowApprovalController _workflowController;
  late final LevelController _levelController;

  String _selectedDocType = 'ឯកសារចូល';
  final List<String> _docTypes = ['ឯកសារចូល', 'ឯកសារចេញ'];

  @override
  void initState() {
    super.initState();
    _workflowController = Get.find<WorkflowApprovalController>();
    _levelController = Get.find<LevelController>();
    _workflowController.clearApprovalSteps();
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
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Form Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepHeader(),
                const SizedBox(height: 30),
                Obx(() {
                  _workflowController.initializeDefaultSteps();
                  if (_levelController.levels.isEmpty) return const SizedBox.shrink();
                  return DropdownField(
                    label: "កម្រិត",
                    value: _levelController.selectedLevel.value,
                    items: _levelController.levels.map((l) => l.name).toList(),
                    onChanged: (val) {
                      if (val != null) _levelController.selectLevel(val);
                    },
                    headerLabel: 'គោលដៅ',
                  );
                }),
                const SizedBox(height: 20),
                DropdownField(
                  label: "ប្រភេទ",
                  value: _selectedDocType,
                  items: _docTypes,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDocType = val);
                  },
                  headerLabel: 'គោលដៅ',
                ),
                const SizedBox(height: 30),
                Text("លំដាប់លំហូរឯកសារ", style: AppTextStyles.title3),
                const SizedBox(height: 10),
                Obx(() {
                  if (_levelController.levels.isEmpty) return const SizedBox.shrink();
                  final levelNames = _levelController.levels.map((l) => l.name).toList();
                  return Column(
                    children: _workflowController.approvalSteps.asMap().entries.map((entry) {
                      int idx = entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DropdownField(
                          label: "ទី ${idx + 1}",
                          value: entry.value.level,
                          items: levelNames,
                          onChanged: (val) {
                            if (val != null) {
                              _workflowController.updateStepAt(idx, val, 'Step ${idx + 1}');
                            }
                          },
                          headerLabel: 'គោលដៅ',
                        ),
                      );
                    }).toList(),
                  );
                }),
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add, size: 20, color: AppColors.grey),
                    label: const Text('បន្ថែម',
                        style: TextStyle(color: Color.fromARGB(255, 90, 93, 98))),
                    onPressed: () => _workflowController.addStep(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: AppColors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: widget.onCancel,
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
                      child: ButtonWidget(
                        text: "បន្ត",
                        onPressed: () {
                          _workflowController.setDocumentTypeAndProceed(_selectedDocType, widget.onContinue);
                        },
                      ),
                    ),
                  ],
                ),
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
        StepArrowData(title: 'ជំហានទី ១', isActive: true),
        StepArrowData(title: 'ជំហានទី ២', isActive: false),
      ],
    );
  }
}