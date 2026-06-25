import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';

abstract class SendDocumentRepository {
  Future<List<OutgoingDocumentModel>> fetchOutgoingDocuments();
  Future<void> saveOutgoingDocument(OutgoingDocumentModel doc);
  Future<OutgoingDocumentModel?> getOutgoingDocumentById(int id);
}
