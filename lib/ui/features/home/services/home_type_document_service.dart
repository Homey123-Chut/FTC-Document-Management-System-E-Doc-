import 'package:e_doc_redo/data/models/document/type_document.dart';
import 'package:e_doc_redo/data/repositories/document/type_document_repository.dart';

class TypeDocumentService {
  final TypeDocumentRepository repository;

  TypeDocumentService({required this.repository});

  Future<List<TypeDocumentModel>> fetchTypes() async {
    return repository.getTypes();
  }
}
