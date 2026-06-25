import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/repositories_impl/workflow_approval_repository_impl.dart';

class ApprovalWorkflowSearchRepository {
  final WorkflowApprovalRepositoryImpl _dataSource;

  ApprovalWorkflowSearchRepository(this._dataSource);

  /// Returns all workflows matching [query] (case-insensitive).
  /// Searches both Khmer and Latin title fields.
  Future<List<ApprovalWorkflowModel>> search(String query) async {
    final all = await _dataSource.getAllWorkflows();
    final q = query.toLowerCase();
    return all.where((w) {
      return w.workflowTitleKhmer.toLowerCase().contains(q) ||
          w.workflowTitleLatin.toLowerCase().contains(q);
    }).toList();
  }
}
