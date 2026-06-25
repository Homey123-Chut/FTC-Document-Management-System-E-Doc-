import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/document_type/repositories_impl/document_repository_impl.dart';

/// Pure Dart service — no GetX dependency.
/// Wraps search operations on [DocumentRepositoryImpl].
class SearchService {
  final DocumentRepositoryImpl repository;

  SearchService({DocumentRepositoryImpl? repository})
      : repository = repository ?? DocumentRepositoryImpl();

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
