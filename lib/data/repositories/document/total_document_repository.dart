

import 'package:e_doc_redo/data/models/document/total_document.dart';

abstract class TotalDocumentRepository {
  Future<List<TotalDocumentModel>> getTotals();
}
