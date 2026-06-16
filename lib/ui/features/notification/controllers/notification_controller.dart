import 'package:e_doc_redo/ui/features/notification/repository_impl/notification_repository_impl.dart';
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

  void markAllAsRead() {
    if (notifications.any((item) => !item.isRead)) {
      final updated = notifications.map((n) {
        return n.isRead ? n : NotificationModel(
          id: n.id,
          title: n.title,
          date: n.date,
          time: n.time,
          description: n.description,
          categoryGroup: n.categoryGroup,
          isRead: true,
        );
      }).toList();
      notifications.assignAll(updated);
    }
  }
}
