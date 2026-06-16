import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/data/repositories/document/document_repository.dart';

/// Pure Dart service — no GetX dependency.
/// Wraps search operations on [DocumentRepository].
class SearchService {
  final DocumentRepository repository;

  SearchService({required this.repository});

  Future<List<DocumentModel>> searchDocuments({
    required DocumentType type,
    String documentNumber = '',
    String title = '',
  }) async {
    return repository.searchDocuments(
      type: type.name,
      documentNumber: documentNumber,
      title: title,
    );
  }
}
