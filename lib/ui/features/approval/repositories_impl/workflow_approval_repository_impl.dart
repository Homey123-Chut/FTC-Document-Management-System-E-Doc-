import 'dart:convert';

import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/data/repositories/approval/workflow_approval_repository.dart';
import 'package:flutter/services.dart';


class WorkflowApprovalRepositoryImpl
    implements WorkflowApprovalRepository {
  @override
  Future<List<ApprovalWorkflowModel>> getAllWorkflows() async {
    final jsonString = await rootBundle.loadString(
      'lib/data/mock_data/approval_workflow.json',
    );

    final jsonData = jsonDecode(jsonString);

    return (jsonData['workflows'] as List)
        .map((e) => ApprovalWorkflowModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> createWorkflow(
    ApprovalWorkflowModel workflow,
  ) async {}

  @override
  Future<void> updateWorkflow(
    ApprovalWorkflowModel workflow,
  ) async {}

  @override
  Future<void> deleteWorkflow(
    String workflowId,
  ) async {}

  @override
  Future<ApprovalWorkflowModel?> getWorkflowById(
    String workflowId,
  ) async {
    final workflows = await getAllWorkflows();

    try {
      return workflows.firstWhere(
        (element) => element.id == workflowId,
      );
    } catch (_) {
      return null;
    }
  }
}