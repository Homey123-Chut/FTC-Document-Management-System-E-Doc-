import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/repositories_impl/approval_workflow_search_repository.dart';

class ApprovalWorkflowSearchService {
  final ApprovalWorkflowSearchRepository _repository;

  ApprovalWorkflowSearchService(this._repository);

  Future<List<ApprovalWorkflowModel>> search(String query) {
    return _repository.search(query);
  }
}
