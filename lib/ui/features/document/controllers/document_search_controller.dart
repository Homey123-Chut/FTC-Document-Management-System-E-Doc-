import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/home/repository_impl/mock_document_repository.dart';
import 'package:e_doc_redo/ui/features/document/services/document_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentSearchController extends GetxController {
  final DocumentService service;
  final DocumentType type;

  DocumentSearchController({
    required this.type,
    DocumentService? service,
  }) : service = service ??
            DocumentService(repository: DocumentMockRepository());

  final searchResults = <DocumentModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final hasSearched = false.obs;

  final documentNumberCtrl = TextEditingController();
  final titleCtrl = TextEditingController();

  bool get _hasNoSearchCriteria =>
      documentNumberCtrl.text.trim().isEmpty && titleCtrl.text.trim().isEmpty;

  Future<void> performSearch() async {
    if (_hasNoSearchCriteria) {
      error.value = 'សូមបញ្ចូលលេខឯកសារ ឬចំណងជើង';
      return;
    }

    isLoading.value = true;
    error.value = '';
    hasSearched.value = true;

    try {
      final results = await service.searchDocuments(
        type: type,
        documentNumber: documentNumberCtrl.text.trim(),
        title: titleCtrl.text.trim(),
      );
      searchResults.assignAll(results);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    documentNumberCtrl.clear();
    titleCtrl.clear();
    searchResults.clear();
    error.value = '';
    hasSearched.value = false;
  }

  @override
  void onClose() {
    documentNumberCtrl.dispose();
    titleCtrl.dispose();
    super.onClose();
  }
}
