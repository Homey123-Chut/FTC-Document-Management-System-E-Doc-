import 'package:e_doc_redo/data/models/notification/notification.dart';
import 'package:e_doc_redo/ui/features/notification/controllers/notification_controller.dart';
import 'package:e_doc_redo/ui/features/notification/views/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationContent extends StatelessWidget {
  final NotificationController controller;

  const NotificationContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B5ECF)),
          ),
        );
      }

     if (controller.notifications.isEmpty) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC), 
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined, 
              size: 48,
              color: Color(0xFF8A92A6), 
            ),
          ),
          
          const SizedBox(height: 12),

          const Text(
            'មិនមានការជូនដំណឹង',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555962), 
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'បច្ចុប្បន្នមិនមានការជូនដំណឹងណាមួយទេ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF8A92A6), 
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}

      final grouped = <String, List<NotificationModel>>{};
      for (final item in controller.notifications) {
        grouped.putIfAbsent(item.categoryGroup, () => []).add(item);
      }

      final orderedKeys = <String>[];
      if (grouped.containsKey('ថ្ងៃនេះ')) orderedKeys.add('ថ្ងៃនេះ');
      if (grouped.containsKey('ម្សិលមិញ')) orderedKeys.add('ម្សិលមិញ');
      for (final key in grouped.keys) {
        if (!orderedKeys.contains(key)) orderedKeys.add(key);
      }

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (int i = 0; i < orderedKeys.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _sectionHeader(
              orderedKeys[i],
              showMarkRead: orderedKeys[i] == 'ថ្ងៃនេះ',
              onMarkRead: controller.markAllAsRead,
            ),
            ...grouped[orderedKeys[i]]!.map(_buildCard),
          ],
        ],
      );
    });
  }

  Widget _buildCard(NotificationModel item) => NotificationCard(
        title: item.title,
        date: item.date,
        time: item.time,
        description: item.description,
        icon: item.computedIcon,
      );

  Widget _sectionHeader(
    String title, {
    bool showMarkRead = false,
    VoidCallback? onMarkRead,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575),
            ),
          ),
          if (showMarkRead && onMarkRead != null)
            OutlinedButton.icon(
              onPressed: onMarkRead,
              icon: const Icon(Icons.check_box_outlined,
                  size: 14, color: Color(0xFF757575)),
              label: const Text('សម្គាល់អានហើយ',
                  style: TextStyle(fontSize: 12, color: Color(0xFF757575))),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
        ],
      ),
    );
  }
}
