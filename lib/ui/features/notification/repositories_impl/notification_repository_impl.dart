import 'dart:convert';

import 'package:e_doc_redo/data/models/notification/notification_date.dart';
import 'package:e_doc_redo/data/models/notification/notification.dart';
import 'package:e_doc_redo/data/repositories/notification/notification_repository.dart';
import 'package:flutter/services.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final jsonString =
        await rootBundle.loadString('lib/data/mock_data/notifications.json');
    final List<dynamic> groups = jsonDecode(jsonString);

    final List<NotificationModel> all = [];
    for (final group in groups) {
      final dateModel =
          NotificationDateModel.fromJson(group as Map<String, dynamic>);
      all.addAll(dateModel.notifications);
    }
    return all;
  }
}
