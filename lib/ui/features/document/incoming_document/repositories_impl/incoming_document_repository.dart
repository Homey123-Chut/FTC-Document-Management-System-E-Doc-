import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';

/// Repository contract for incoming document approval operations.
abstract class IncomingDocumentRepository {
  /// Fetches all documents that have at least one pending approval step.
  /// For single-user demo: returns all outgoing documents regardless of user.
  Future<List<OutgoingDocumentModel>> getIncomingDocuments();

  /// Fetches a single document by its [id].
  Future<OutgoingDocumentModel?> getDocumentById(String id);

  /// Approves the current pending step (lowest stepNumber with status='pending').
  /// Updates step status to 'approved', sets actionDate, and recalculates
  /// overall document status.
  Future<OutgoingDocumentModel> approveStep(String documentId);

  /// Rejects the current pending step with an optional [comment].
  /// Updates step status to 'rejected' and sets overall doc status to rejected.
  Future<OutgoingDocumentModel> rejectStep(String documentId,
      {String? comment});
}
