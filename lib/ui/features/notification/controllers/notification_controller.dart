import 'package:e_doc_redo/ui/features/notification/repositories_impl/notification_repository_impl.dart';
import 'package:e_doc_redo/data/models/notification/notification.dart';
import 'package:e_doc_redo/ui/features/notification/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationService service;

  NotificationController({NotificationService? service}) : service = service ?? NotificationService(MockNotificationRepository());

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final results = await service.getNotifications();
      notifications.assignAll(results);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, List<NotificationModel>> get groupedNotifications {
    final grouped = <String, List<NotificationModel>>{};
    for (final item in notifications) {
      grouped.putIfAbsent(item.categoryGroup, () => []).add(item);
    }

    final ordered = <String, List<NotificationModel>>{};
    if (grouped.containsKey('ថ្ងៃនេះ')) {
      ordered['ថ្ងៃនេះ'] = grouped['ថ្ងៃនេះ']!;
    }
    if (grouped.containsKey('ម្សិលមិញ')) {
      ordered['ម្សិលមិញ'] = grouped['ម្សិលមិញ']!;
    }
    for (final key in grouped.keys) {
      ordered.putIfAbsent(key, () => grouped[key]!);
    }
    return ordered;
  }

  void markAllAsRead() {
    if (notifications.any((item) => !item.isRead)) {
      final updated = notifications
          .map((n) => n.isRead ? n : n.copyWith(isRead: true))
          .toList();
      notifications.assignAll(updated);
    }
  }
}
