import 'dart:convert';

import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/data/repositories/approval/workflow_approval_repository.dart';
import 'package:flutter/services.dart';


class WorkflowApprovalRepositoryImpl
    implements WorkflowApprovalRepository {
  List<ApprovalWorkflowModel>? _cachedWorkflows;

  Future<List<ApprovalWorkflowModel>> _loadAll() async {
    if (_cachedWorkflows != null) return _cachedWorkflows!;

    final jsonString = await rootBundle.loadString(
      'lib/data/mock_data/approval_workflow.json',
    );

    final jsonData = jsonDecode(jsonString);

    _cachedWorkflows = (jsonData['workflows'] as List)
        .map((e) => ApprovalWorkflowModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cachedWorkflows!;
  }

  @override
  Future<List<ApprovalWorkflowModel>> getAllWorkflows() => _loadAll();

  @override
  Future<void> createWorkflow(
    ApprovalWorkflowModel workflow,
  ) async {
    final all = await _loadAll();
    all.insert(0, workflow);
  }

  @override
  Future<void> updateWorkflow(
    ApprovalWorkflowModel workflow,
  ) async {
    final all = await _loadAll();
    final idx = all.indexWhere((w) => w.id == workflow.id);
    if (idx != -1) all[idx] = workflow;
  }

  @override
  Future<void> deleteWorkflow(
    String workflowId,
  ) async {
    final all = await _loadAll();
    all.removeWhere((w) => w.id == workflowId);
  }

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