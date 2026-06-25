import 'package:e_doc_redo/data/models/notification/notification.dart';
import 'package:e_doc_redo/data/repositories/notification/notification_repository.dart';

class NotificationService {
  final NotificationRepository _repository;

  NotificationService(this._repository);

  Future<List<NotificationModel>> getNotifications() {
    return _repository.fetchNotifications();
  }

  Future<List<NotificationModel>> searchNotifications(String query) async {
    final all = await _repository.fetchNotifications();
    final q = query.toLowerCase();
    return all.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.description.toLowerCase().contains(q);
    }).toList();
  }
}
