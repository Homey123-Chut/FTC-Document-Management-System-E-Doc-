
import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';

abstract class WorkflowApprovalRepository {
  Future<List<ApprovalWorkflowModel>> getAllWorkflows();

  Future<void> createWorkflow(
    ApprovalWorkflowModel workflow,
  );

  Future<void> updateWorkflow(
    ApprovalWorkflowModel workflow,
  );

  Future<void> deleteWorkflow(
    String workflowId,
  );

  Future<ApprovalWorkflowModel?> getWorkflowById(
    String workflowId,
  );
}