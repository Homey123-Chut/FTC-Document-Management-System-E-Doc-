import 'package:e_doc_redo/ui/features/main/main_screen.dart';
import 'package:e_doc_redo/ui/features/notification/controllers/notification_controller.dart';
import 'package:e_doc_redo/ui/features/notification/controllers/notification_search_controller.dart';
import 'package:e_doc_redo/ui/features/notification/views/notification_search_screen.dart';
import 'package:e_doc_redo/ui/features/notification/views/widgets/notification_content.dart';
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
            onBackTap: () => Get.offAll(() => const MainScreen()),
            onSearchTap: () => Get.to(() => const NotificationSearchScreen(),
              binding: BindingsBuilder(() {
                Get.put(NotificationSearchController());
              }),
            ),
          ),
          Expanded(
            child: const NotificationContent(),
          ),
        ],
      ),
    );
  }
}
