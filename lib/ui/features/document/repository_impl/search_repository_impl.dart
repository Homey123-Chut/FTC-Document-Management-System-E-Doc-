import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/repositories/document/document_repository.dart';
import 'package:e_doc_redo/ui/features/document/repository_impl/document_repository_impl.dart';

/// Delegates all calls to [DocumentRepositoryImpl] to eliminate duplicate code.
class SearchRepositoryImpl implements DocumentRepository {
  final DocumentRepositoryImpl _inner = DocumentRepositoryImpl();

  @override
  Future<List<DocumentModel>> getDocuments() => _inner.getDocuments();

  @override
  Future<List<DocumentModel>> getDocumentsByType(String type) =>
      _inner.getDocumentsByType(type);

  @override
  Future<List<DocumentModel>> searchDocuments({
    required String type,
    String documentNumber = '',
    String title = '',
  }) =>
      _inner.searchDocuments(
          type: type, documentNumber: documentNumber, title: title);

  @override
  Future<DocumentModel> getDocumentById(String id) =>
      _inner.getDocumentById(id);

  @override
  Future<void> addDocument(DocumentModel document, String type) =>
      _inner.addDocument(document, type);

  @override
  Future<void> updateDocument(DocumentModel document) =>
      _inner.updateDocument(document);
}
