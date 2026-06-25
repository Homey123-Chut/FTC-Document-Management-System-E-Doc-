import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/data/repositories/document/total_document_repository.dart';

class TotalDocumentService {
  final TotalDocumentRepository repository;

  TotalDocumentService({required this.repository});

  Future<List<DocumentSummaryModel>> fetchTotals() {
    return repository.getTotals();
  }
}
