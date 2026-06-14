import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/data/models/user/user.dart';

/// Repository that aggregates data for the document detail screen.
abstract class DocumentDetailRepository {
  Future<OutgoingDocumentModel?> getOutgoingDocumentById(String id);
  Future<List<ApprovalWorkflowModel>> getWorkflows();
  Future<UserModel?> getUserById(String id);
}
