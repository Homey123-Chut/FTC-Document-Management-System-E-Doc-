import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:get/get.dart';


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

  Future<void> createWorkflow(
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
}