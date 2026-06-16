import 'package:e_doc_redo/ui/features/notification/controllers/notification_controller.dart';
import 'package:e_doc_redo/ui/features/notification/screens/widgets/notification_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          TopNavBarWidget(
            title: 'ការជូនដំណឹង',
            onSearchTap: () {},
          ),
          Expanded(
            child: NotificationContent(controller: controller),
          ),
        ],
      ),
    );
  }
}
