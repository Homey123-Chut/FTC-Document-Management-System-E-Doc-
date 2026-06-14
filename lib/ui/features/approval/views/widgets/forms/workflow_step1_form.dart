

import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/ui/features/approval/controllers/level_workflow_controller.dart';
import 'package:e_doc_redo/ui/features/approval/controllers/workflow_approval_controller.dart';
import 'package:e_doc_redo/ui/widgets/action/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/input/edoc_dropdown_field.dart';
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
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _workflowController = Get.find<WorkflowApprovalController>();
    _levelController = Get.find<LevelController>();
    _workflowController.clearApprovalSteps();
  }

  void _initializeStepsIfNeeded() {
    if (_initialized) return;
    if (_levelController.levels.isEmpty) return;

    _initialized = true;
    final defaultLevel = _levelController.selectedLevel.value.isNotEmpty
        ? _levelController.selectedLevel.value
        : _levelController.levels.first.name;

    _workflowController.addApprovalStep(
      ApprovalStepModel(stepNumber: 1, level: defaultLevel, flowLevel: 'Step 1'),
    );
    _workflowController.addApprovalStep(
      ApprovalStepModel(stepNumber: 2, level: defaultLevel, flowLevel: 'Step 2'),
    );
  }

  void _addStep() {
    final steps = _workflowController.approvalSteps;
    final defaultLevel = _levelController.selectedLevel.value.isNotEmpty
        ? _levelController.selectedLevel.value
        : _levelController.levels.first.name;

    _workflowController.addApprovalStep(
      ApprovalStepModel(
        stepNumber: steps.length + 1,
        level: defaultLevel,
        flowLevel: 'Step ${steps.length + 1}',
      ),
    );
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
                  _initializeStepsIfNeeded();
                  if (_levelController.levels.isEmpty) return const SizedBox.shrink();
                  return DropdownField(
                    label: "កម្រិត",
                    value: _levelController.selectedLevel.value,
                    items: _levelController.levels.map((l) => l.name).toList(),
                    onChanged: (val) {
                      if (val != null) _levelController.selectLevel(val);
                    },
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
                ),
                const SizedBox(height: 30),
                Text("លំដាប់លំហូរឯកសារ", style: AppTextStyles.label2),
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
                              final steps = List<ApprovalStepModel>.from(_workflowController.approvalSteps);
                              steps[idx] = ApprovalStepModel(
                                stepNumber: idx + 1, level: val, flowLevel: 'Step ${idx + 1}',
                              );
                              _workflowController.approvalSteps.assignAll(steps);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  );
                }),
                ButtonWidget(
                  text: "បន្ថែម",
                  icon: Icons.add,
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.grey,
                  onPressed: _addStep,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: "បោះបង់",
                        backgroundColor: const Color(0xFFF5F5F5),
                        foregroundColor: Colors.black,
                        onPressed: widget.onCancel,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ButtonWidget(
                        text: "បន្ត",
                        onPressed: () {
                          _workflowController.selectedDocumentType.value = _selectedDocType;
                          widget.onContinue();
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
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ClipPath(
              clipper: ArrowClipper(isLast: false),
              child: Container(
                color: AppColors.darkBlue,
                alignment: Alignment.center,
                child: const Text("ជំហានទី ១", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            child: ClipPath(
              clipper: ArrowClipper(isLast: true),
              child: Container(
                color: const Color(0xFFE8EAF6),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 2),
                child: const Text("ជំហានទី ២", style: TextStyle(color: Color(0xFF757575))),
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
  ArrowClipper({required this.isLast, bool isFirst = false});

  @override
  Path getClip(Size size) {
    final path = Path();
    double startX = isLast ? 15.0 : 0.0;
    path.moveTo(startX, 0);
    path.lineTo(size.width - 15, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 15, size.height);
    path.lineTo(startX, size.height);
    if (isLast) path.lineTo(startX + 15, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}