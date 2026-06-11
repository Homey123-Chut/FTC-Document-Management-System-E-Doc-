
import 'package:e_doc_redo/data/models/document/document.dart';

abstract class DocumentRepository {
  Future<List<DocumentModel>> getDocuments();
  Future<DocumentModel> getDocumentById(String id);

  Future<void> addDocument(DocumentModel document);
  Future<void> updateDocument(DocumentModel document);
}