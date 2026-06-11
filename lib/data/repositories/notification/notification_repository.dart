import 'package:e_doc_redo/data/models/notification/notification.dart';


abstract class NotificationRepository {
  Future<List<NotificationModel>> fetchNotifications();
}