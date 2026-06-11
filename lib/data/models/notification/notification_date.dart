
import 'package:e_doc_redo/data/models/notification/notification.dart';

class NotificationDateModel {
  final String categoryGroup;
  final List<NotificationModel> notifications;

  NotificationDateModel({
    required this.categoryGroup,
    required this.notifications,
  });

  factory NotificationDateModel.fromJson(Map<String, dynamic> json) {
    return NotificationDateModel(
      categoryGroup: json['category_group'] ?? '',
      notifications: (json['notifications'] as List<dynamic>? ?? [])
          .map((e) => NotificationModel.fromJson(
                e,
                categoryGroup: json['category_group'],
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_group': categoryGroup,
      'notifications': notifications.map((e) => e.toJson()).toList(),
    };
  }
}