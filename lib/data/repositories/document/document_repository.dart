import 'package:e_doc_redo/data/models/document/document.dart';

abstract class DocumentRepository {
  Future<List<DocumentModel>> getDocuments();

  Future<List<DocumentModel>> getDocumentsByType(String type);

  Future<List<DocumentModel>> searchDocuments({
    required String type,
    String documentNumber = '',
    String title = '',
  });

  Future<DocumentModel> getDocumentById(String id);

  Future<void> addDocument(DocumentModel document, String type);
  Future<void> updateDocument(DocumentModel document);
}
