import 'package:e_doc_redo/data/models/document/total_document.dart';
import 'package:e_doc_redo/data/repositories/document/total_document_repository.dart';

class TotalDocumentService {
  final TotalDocumentRepository repository;

  TotalDocumentService({required this.repository});

  Future<List<TotalDocumentModel>> fetchTotals() {
    return repository.getTotals();
  }
}
