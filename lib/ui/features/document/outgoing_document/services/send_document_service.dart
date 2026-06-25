import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_reference.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/data/repositories/document/document_repository.dart';
import 'package:e_doc_redo/data/repositories/document/send_document_repository.dart';
import 'package:e_doc_redo/data/repositories/approval_workflow/workflow_approval_repository.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/repositories_impl/send_document_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/document_type/repositories_impl/document_repository_impl.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/repositories_impl/workflow_approval_repository_impl.dart';

/// Service for the Send Document 3-step flow.
/// Orchestrates document lookup and workflow template retrieval.
class SendDocumentService {
  final SendDocumentRepository sendDocRepo;
  final DocumentRepository documentRepo;
  final WorkflowApprovalRepository workflowRepo;

  SendDocumentService({
    SendDocumentRepository? sendDocRepo,
    DocumentRepository? documentRepo,
    WorkflowApprovalRepository? workflowRepo,
  })  : sendDocRepo = sendDocRepo ?? SendDocumentRepositoryImpl(),
        documentRepo = documentRepo ?? DocumentRepositoryImpl(),
        workflowRepo = workflowRepo ?? WorkflowApprovalRepositoryImpl();

  /// Fetches ALL created documents from personal/general/incoming types
  /// and returns them as [DocumentReferenceModel] for the Step 1 dropdown.
  Future<List<DocumentReferenceModel>> fetchAllCreatedDocuments() async {
    final allDocs = await documentRepo.getDocuments();
    return allDocs.map((doc) {
      return DocumentReferenceModel(
        id: doc.id,
        documentNumber: doc.documentNumber,
        titleKhmer: doc.titleKhmer,
        type: 'personal',
      );
    }).toList();
  }

  /// Fetches ALL documents with full [DocumentModel] data for step 3 preview.
  Future<List<DocumentModel>> fetchAllDocumentsFull() async {
    return documentRepo.getDocuments();
  }

  /// Fetches all workflow templates from approval_workflow.json.
  Future<List<ApprovalWorkflowModel>> fetchWorkflowTemplates() async {
    return workflowRepo.getAllWorkflows();
  }

  /// Persists a newly sent outgoing document.
  Future<void> saveOutgoingDocument(OutgoingDocumentModel doc) async {
    return sendDocRepo.saveOutgoingDocument(doc);
  }

  /// Retrieves an outgoing document by its ID.
  Future<OutgoingDocumentModel?> getOutgoingDocumentById(String id) async {
    final docId = int.tryParse(id) ?? 0;
    return sendDocRepo.getOutgoingDocumentById(docId);
  }
}
