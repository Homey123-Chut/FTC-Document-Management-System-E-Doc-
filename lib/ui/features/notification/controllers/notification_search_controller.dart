import 'package:e_doc_redo/data/models/notification/notification.dart';
import 'package:e_doc_redo/ui/features/notification/services/notification_service.dart';
import 'package:e_doc_redo/ui/features/notification/repositories_impl/notification_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSearchController extends GetxController {
  final NotificationService service;

  NotificationSearchController({NotificationService? service}) : service = service ?? NotificationService(MockNotificationRepository());

  final searchCtrl = TextEditingController();
  final searchQuery = ''.obs;
  final searchResults = <NotificationModel>[].obs;
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
      final results = await service.searchNotifications(query);
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
