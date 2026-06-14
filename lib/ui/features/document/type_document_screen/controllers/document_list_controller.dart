import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/data/repositories_impl/document_mock_repository.dart';
import 'package:e_doc_redo/ui/features/document/type_document_screen/services/document_service.dart';
import 'package:get/get.dart';

class DocumentListController extends GetxController {
  final DocumentService service;
  final DocumentType type;

  DocumentListController({
    required this.type,
    DocumentService? service,
  }) : service = service ??
            DocumentService(repository: DocumentMockRepository());

  final documents = <DocumentModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get hasData => documents.isNotEmpty;

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

  @override
  Future<void> refresh() async => loadDocuments();

  @override
  void onInit() {
    loadDocuments();
    super.onInit();
  }
}
