import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/notification/notification.dart';
import 'package:e_doc_redo/ui/features/notification/controllers/notification_controller.dart';
import 'package:e_doc_redo/ui/features/notification/views/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationContent extends GetView<NotificationController> {
  const NotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ── Loading ────────────────────────────────────────────────────
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightBlue),
          ),
        );
      }

      // ── Empty ──────────────────────────────────────────────────────
      if (controller.notifications.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
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
                Text(
                  'មិនមានការជូនដំណឹង',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title5.copyWith(
                    color: const Color(0xFF8A92A6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'បច្ចុប្បន្នមិនមានការជូនដំណឹងណាមួយទេ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body3,
                ),
              ],
            ),
          ),
        );
      }

      // ── Data ───────────────────────────────────────────────────────
      final grouped = controller.groupedNotifications;

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (int i = 0; i < grouped.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),

            // ── Section header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 12, bottom: 4),
              child: _SectionHeaderRow(
                title: grouped.keys.elementAt(i),
                todayItems: grouped.keys.elementAt(i) == 'ថ្ងៃនេះ'
                    ? grouped.values.elementAt(i)
                    : null,
                onMarkRead: controller.markAllAsRead,
              ),
            ),

            // ── Notification cards ─────────────────────────────────
            ...grouped.values.elementAt(i).map(
                  (item) => NotificationCard(
                    title: item.title,
                    date: item.date,
                    time: item.time,
                    description: item.description,
                    icon: item.computedIcon,
                    isRead: item.isRead,
                  ),
                ),
          ],
        ],
      );
    });
  }
}

// ─── Section header row ────────────────────────────────────────────────────

/// A row showing the section title and, for the "today" section, a
/// mark-all-as-read button that changes appearance once every item is read.
class _SectionHeaderRow extends StatelessWidget {
  final String title;
  final List<NotificationModel>? todayItems;
  final VoidCallback? onMarkRead;

  const _SectionHeaderRow({
    required this.title,
    this.todayItems,
    this.onMarkRead,
  });

  bool get _isToday => todayItems != null;
  bool get _allRead =>
      _isToday && todayItems!.isNotEmpty && todayItems!.every((n) => n.isRead);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.label4),

        // ── Mark-read button (today section only) ───────────────────
        if (_isToday && onMarkRead != null)
          OutlinedButton.icon(
            onPressed: _allRead ? null : onMarkRead,
            icon: Icon(
              _allRead ? Icons.check_box : Icons.check_box_outlined,
              size: 16,
              color: _allRead ? Colors.white : const Color(0xFF757575),
            ),
            label: Text(
              _allRead
                  ? 'អានហើយ'
                  : 'សម្គាល់អានហើយ',
              style: TextStyle(
                fontSize: 14,
                color: _allRead ? Colors.white : const Color(0xFF757575),
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              backgroundColor:
                  _allRead ? AppColors.lightBlue : null,
              side: _allRead
                  ? BorderSide.none
                  : BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}
