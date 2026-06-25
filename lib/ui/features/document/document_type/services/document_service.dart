import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/data/repositories/document/document_repository.dart';

class DocumentService {
  final DocumentRepository repository;

  DocumentService({required this.repository});

  Future<List<DocumentModel>> getDocumentsByType(DocumentType type) async {
    return repository.getDocumentsByType(type.name);
  }

  Future<List<DocumentModel>> searchDocuments({
    required DocumentType type,
    String documentNumber = '',
    String title = '',
  }) async {
    return repository.searchDocuments(
      type: type.name,
      documentNumber: documentNumber,
      title: title,
    );
  }
  Future<DocumentModel> getDocumentById(String id) async {
    return repository.getDocumentById(id);
  }

  Future<void> createDocument(DocumentModel document, DocumentType type) async {
    return repository.addDocument(document, type.name);
  }
  Future<void> updateDocument(DocumentModel document) async {
    return repository.updateDocument(document);
  }

  // ── Recently created documents ───────────────────────────────────

  /// Returns documents that were recently created with draft/pending status.
  Future<List<DocumentModel>> getRecentDocuments() async {
    return repository.getRecentDocuments();
  }

  // ── Send documents ───────────────────────────────────────────────

  /// Sends the documents with the given [ids].
  /// Changes their status from draft → sent and persists.
  Future<void> sendDocuments(List<int> ids) async {
    if (ids.isEmpty) return;
    await repository.sendDocuments(ids);
  }
}
