import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String description;
  final String categoryGroup;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.categoryGroup,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, {String? categoryGroup}) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
      categoryGroup: categoryGroup ?? json['category_group'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'description': description,
      'category_group': categoryGroup,
      'is_read': isRead,
    };
  }

  IconData get computedIcon {
    return isRead ? Icons.notifications_none_rounded : Icons.notifications_active_rounded;
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? description,
    String? categoryGroup,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      categoryGroup: categoryGroup ?? this.categoryGroup,
      isRead: isRead ?? this.isRead,
    );
  }
}