import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/document_type/services/document_service.dart';
import 'package:e_doc_redo/ui/features/document/document_type/repositories_impl/document_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentSearchController extends GetxController {
  final DocumentService service;
  final DocumentType type;

  DocumentSearchController({
    required this.type,
    DocumentService? service,
  }) : service = service ??
            DocumentService(repository: DocumentRepositoryImpl());

  final searchCtrl = TextEditingController();
  final searchQuery = ''.obs;
  final searchResults = <DocumentModel>[].obs;
  final isLoading = false.obs;

  void onSearchChanged(String query) {
    searchQuery.value = query.trim();
    if (searchQuery.value.isEmpty) {
      searchResults.clear();
      return;
    }
    _performSearch(searchQuery.value);
  }

  Future<void> _performSearch(String query) async {
    isLoading.value = true;
    try {
      final results = await service.searchDocuments(
        type: type,
        documentNumber: query,
        title: query,
      );
      searchResults.assignAll(results);
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchCtrl.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
