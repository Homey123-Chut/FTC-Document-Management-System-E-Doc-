import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/data/repositories/document/document_repository.dart';

/// Pure Dart service — no GetX dependency.
/// Contains business logic for document operations.
/// Calls the abstract [DocumentRepository] so it can work with
/// mock or remote implementations without changing this class.
class DocumentService {
  final DocumentRepository repository;

  DocumentService({required this.repository});

  /// Fetches all documents of a given [type].
  Future<List<DocumentModel>> getDocumentsByType(DocumentType type) async {
    return repository.getDocumentsByType(type.name);
  }

  /// Searches documents by [type], optionally filtered by
  /// [documentNumber] and/or [title] (matches titleKhmer or titleLatin).
  ///
  /// If both [documentNumber] and [title] are empty, returns an empty list.
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

  /// Fetches a single document by its [id].
  Future<DocumentModel> getDocumentById(String id) async {
    return repository.getDocumentById(id);
  }

  /// Creates a new document and persists it via the repository.
  Future<void> createDocument(DocumentModel document, DocumentType type) async {
    return repository.addDocument(document, type.name);
  }

  /// Updates an existing document via the repository.
  /// Used primarily to change the status of outgoing documents.
  Future<void> updateDocument(DocumentModel document) async {
    return repository.updateDocument(document);
  }
}
