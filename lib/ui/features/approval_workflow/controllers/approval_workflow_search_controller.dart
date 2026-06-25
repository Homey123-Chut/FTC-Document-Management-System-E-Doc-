import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/repositories_impl/approval_workflow_search_repository.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/repositories_impl/workflow_approval_repository_impl.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/services/approval_workflow_search_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalWorkflowSearchController extends GetxController {
  late final ApprovalWorkflowSearchService service;

  final searchCtrl = TextEditingController();
  final searchQuery = ''.obs;
  final searchResults = <ApprovalWorkflowModel>[].obs;
  final isLoading = false.obs;

  ApprovalWorkflowSearchController() {
    service = ApprovalWorkflowSearchService(
      ApprovalWorkflowSearchRepository(WorkflowApprovalRepositoryImpl()),
    );
  }

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
      final results = await service.search(query);
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
