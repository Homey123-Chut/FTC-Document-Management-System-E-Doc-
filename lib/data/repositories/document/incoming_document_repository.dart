import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';

abstract class IncomingDocumentRepository {
 
  Future<List<OutgoingDocumentModel>> getIncomingDocuments();

  Future<OutgoingDocumentModel?> getDocumentById(String id);

  Future<OutgoingDocumentModel> approveStep(String documentId);

 
  Future<OutgoingDocumentModel> rejectStep(String documentId, {String? comment});
}
