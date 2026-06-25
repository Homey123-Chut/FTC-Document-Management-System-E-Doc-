import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/data/repositories/document/type_document_repository.dart';

class TypeDocumentService {
  final TypeDocumentRepository repository;

  TypeDocumentService({required this.repository});

  Future<List<DocumentSummaryModel>> fetchTypes() async {
    return repository.getTypes();
  }
}
