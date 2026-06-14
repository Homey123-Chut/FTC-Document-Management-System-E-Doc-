import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/repositories_impl/document_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/services/document_service.dart';
import 'package:get/get.dart';

/// GetX controller managing documents for a specific [DocumentType].
/// Uses [DocumentService] → [DocumentRepositoryImpl] for data access.
/// Exposes reactive [documents] list for automatic UI updates via Obx.
class DocumentController extends GetxController {
  final DocumentService service;
  final DocumentType type;

  DocumentController({
    required this.type,
    DocumentService? service,
  }) : service = service ??
            DocumentService(repository: DocumentRepositoryImpl());

  final documents = <DocumentModel>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;

  bool get hasData => documents.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
  }

  /// Loads all documents matching the controller's [type].
  Future<void> loadDocuments() async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await service.getDocumentsByType(type);
      documents.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Creates a new document, persists it, and inserts it directly into
  /// the reactive [documents] list for immediate UI update via Obx.
  /// The [document]'s type must match the controller's type.
  Future<void> createDocument(DocumentModel document) async {
    // Insert immediately so the UI updates without waiting for reload
    documents.insert(0, document);

    try {
      await service.createDocument(document, type);
    } catch (e) {
      // Remove on failure
      documents.removeWhere((d) => d.id == document.id);
      error.value = e.toString();
      rethrow;
    }
  }

  /// Updates the status of a document identified by [documentId].
  /// Persists the change via the service and updates the reactive list.
  /// Only relevant for outgoing documents; other types ignore this.
  Future<void> updateDocumentStatus(int documentId, String newStatus) async {
    final idx = documents.indexWhere((d) => d.id == documentId);
    if (idx == -1) return;

    final oldDoc = documents[idx];
    final updated = oldDoc.copyWith(status: newStatus);

    // Optimistic update — UI reflects immediately
    documents[idx] = updated;

    try {
      await service.updateDocument(updated);
    } catch (e) {
      // Revert on failure
      documents[idx] = oldDoc;
      error.value = e.toString();
      rethrow;
    }
  }
}
