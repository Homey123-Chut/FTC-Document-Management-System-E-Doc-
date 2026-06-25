import 'package:e_doc_redo/data/models/document/document_summary.dart';

abstract class TypeDocumentRepository {
  Future<List<DocumentSummaryModel>> getTypes();
}
