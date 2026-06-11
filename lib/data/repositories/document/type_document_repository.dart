import 'package:e_doc_redo/data/models/document/type_document.dart';

abstract class TypeDocumentRepository {
  Future<List<TypeDocumentModel>> getTypes();
}
