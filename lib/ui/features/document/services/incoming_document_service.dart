import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/data/repositories/document/incoming_document_repository.dart';
import 'package:e_doc_redo/ui/features/document/repository_impl/incoming_document_repository_impl.dart';

/// Business logic for incoming document approval workflow.
class IncomingDocumentService {
  final IncomingDocumentRepository repository;

  IncomingDocumentService({IncomingDocumentRepository? repository})
      : repository = repository ?? IncomingDocumentRepositoryImpl();

  /// Gets all incoming documents.
  Future<List<OutgoingDocumentModel>> getIncomingDocuments() async {
    return repository.getIncomingDocuments();
  }

  /// Gets a document by ID.
  Future<OutgoingDocumentModel?> getDocumentById(String id) async {
    return repository.getDocumentById(id);
  }

  /// Approves the current pending step. Returns the updated document.
  Future<OutgoingDocumentModel> approveStep(String documentId) async {
    return repository.approveStep(documentId);
  }

  /// Rejects the current pending step with an optional comment.
  Future<OutgoingDocumentModel> rejectStep(String documentId,
      {String? comment}) async {
    return repository.rejectStep(documentId, comment: comment);
  }

  /// Finds the current pending step in a document (lowest stepNumber with 'pending' status).
  /// Returns null if no pending step (all approved or rejected).
  ApprovalStepModel? findCurrentPendingStep(List<ApprovalStepModel> steps) {
    for (final step in steps) {
      if (step.isPending) return step;
    }
    return null;
  }

  /// Calculates overall document status from step statuses.
  String calculateOverallStatus(List<ApprovalStepModel> steps) {
    if (steps.any((s) => s.isRejected)) return 'បដិសេធ';
    if (steps.every((s) => s.isApproved)) return 'បានអនុម័ត';
    return 'កំពុងរង់ចាំ';
  }

  /// Whether the document has any pending step the user can act on.
  bool canActOnDocument(OutgoingDocumentModel doc) {
    return doc.workflowSteps.any((s) => s.isPending);
  }
}
