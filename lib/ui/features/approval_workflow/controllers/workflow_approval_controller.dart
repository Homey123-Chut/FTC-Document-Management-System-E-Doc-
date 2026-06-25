import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/views/widgets/forms/workflow_create_dialog.dart';
import 'package:e_doc_redo/ui/widgets/notification/message_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'level_workflow_controller.dart';
import '../services/workflow_approval_service.dart';

class WorkflowApprovalController extends GetxController {
  final WorkflowApprovalService service;

  WorkflowApprovalController({
    required this.service,
  });

  final RxList<ApprovalWorkflowModel> workflows =
      <ApprovalWorkflowModel>[].obs;

  final RxList<ApprovalStepModel> approvalSteps =
      <ApprovalStepModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxString selectedDocumentType = ''.obs;

  final isCreatingWorkflow = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkflows();
  }

  Future<void> loadWorkflows() async {
    try {
      isLoading.value = true;

      final result = await service.loadWorkflows();

      workflows.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  void addApprovalStep(
    ApprovalStepModel step,
  ) {
    approvalSteps.add(step);
  }

  void removeApprovalStep(
    int index,
  ) {
    approvalSteps.removeAt(index);
  }

  void clearApprovalSteps() {
    approvalSteps.clear();
  }

  Future<void> saveWorkflow(
    ApprovalWorkflowModel workflow,
  ) async {
    workflows.insert(0, workflow);

    await service.createWorkflow(workflow);
  }

  Future<void> deleteWorkflow(
    String workflowId,
  ) async {
    workflows.removeWhere(
      (element) => element.id == workflowId,
    );

    await service.deleteWorkflow(workflowId);
  }

  /// Shows a confirmation dialog before deleting the workflow.
  Future<void> confirmDeleteWorkflow(String workflowId) async {
    final confirmed = await Get.dialog<bool>(
      const MessageConfirmDialog(
        title: 'លុបលំហូរឯកសារ',
        message: 'តើអ្នកប្រាកដជាចង់លុបលំហូរឯកសារនេះមែនទេ?',
        cancelText: 'បោះបង់',
        confirmText: 'លុប',
        icon: Icons.delete_outline,
      ),
    );

    if (confirmed == true) {
      await deleteWorkflow(workflowId);
    }
  }

  Future<void> updateWorkflow(
    ApprovalWorkflowModel workflow,
  ) async {
    final index = workflows.indexWhere(
      (element) => element.id == workflow.id,
    );

    if (index != -1) {
      workflows[index] = workflow;
    }

    await service.updateWorkflow(workflow);
  }

  void initializeDefaultSteps() {
    if (approvalSteps.isNotEmpty) return;
    final levels = Get.find<LevelController>().levels;
    final defaultLevel = levels.isNotEmpty ? levels.first.name : 'Level 1';
    approvalSteps.addAll([
      ApprovalStepModel(stepNumber: 1, level: defaultLevel, flowLevel: ''),
      ApprovalStepModel(stepNumber: 2, level: defaultLevel, flowLevel: ''),
    ]);
  }

  void addStep() {
    final steps = approvalSteps.toList();
    steps.add(ApprovalStepModel(
      stepNumber: steps.length + 1,
      level: '',
      flowLevel: '',
    ));
    approvalSteps.assignAll(steps);
  }

  void updateStepAt(int index, String level, String flowLevel) {
    final steps = approvalSteps.toList();
    if (index >= 0 && index < steps.length) {
      steps[index] = steps[index].copyWith(level: level, flowLevel: flowLevel);
      approvalSteps.assignAll(steps);
    }
  }

  void setDocumentTypeAndProceed(String docType, VoidCallback onContinue) {
    selectedDocumentType.value = docType;
    onContinue();
  }

  Future<void> createWorkflow({
    required String titleKhmer,
    required String titleLatin,
    required VoidCallback onSuccess,
  }) async {
    isCreatingWorkflow.value = true;
    try {
      final workflow = ApprovalWorkflowModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workflowTitleKhmer: titleKhmer.trim(),
        workflowTitleLatin: titleLatin.trim(),
        description: '',
        documentType: selectedDocumentType.value,
        totalDocuments: 0,
        totalLevels: approvalSteps.length,
        createdAt: DateTime.now(),
        steps: approvalSteps.toList(),
      );
      await saveWorkflow(workflow);
      onSuccess();
      Get.snackbar('ជោគជ័យ', 'លំហូរឯកសារត្រូវបានបង្កើត',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('មានបញ្ហា', 'មិនអាចបង្កើតលំហូរបានទេ: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isCreatingWorkflow.value = false;
    }
  }

  void showCreateDialog() {
    Get.dialog(const WorkflowCreateDialog());
  }

  void goBack() {
    Get.back();
  }
}