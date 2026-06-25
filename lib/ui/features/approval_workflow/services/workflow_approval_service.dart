
import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/data/repositories/approval_workflow/workflow_approval_repository.dart';

class WorkflowApprovalService {
  final WorkflowApprovalRepository repository;

  WorkflowApprovalService(this.repository);

  Future<List<ApprovalWorkflowModel>> loadWorkflows() {
    return repository.getAllWorkflows();
  }

  Future<ApprovalWorkflowModel?> getWorkflowById(
    String workflowId,
  ) {
    return repository.getWorkflowById(workflowId);
  }

  Future<void> createWorkflow(
    ApprovalWorkflowModel workflow,
  ) {
    return repository.createWorkflow(workflow);
  }

  Future<void> updateWorkflow(
    ApprovalWorkflowModel workflow,
  ) {
    return repository.updateWorkflow(workflow);
  }

  Future<void> deleteWorkflow(
    String workflowId,
  ) {
    return repository.deleteWorkflow(workflowId);
  }
}