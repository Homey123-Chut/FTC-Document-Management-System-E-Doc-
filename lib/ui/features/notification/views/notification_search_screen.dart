import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/notification/notification.dart';
import 'package:e_doc_redo/ui/features/notification/controllers/notification_search_controller.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:e_doc_redo/ui/widgets/search/search_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSearchScreen extends GetView<NotificationSearchController> {
  const NotificationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            TopNavBarWidget(
              title: '',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SearchContent<NotificationModel>(
                searchCtrl: controller.searchCtrl,
                searchQuery: controller.searchQuery,
                isLoading: controller.isLoading,
                searchResults: controller.searchResults,
                onSearchChanged: controller.onSearchChanged,
                onClear: controller.clearSearch,
                searchHint: 'ស្វែងរក',
                noResultTitle: 'រកមិនឃើញការជូនដំណឹង',
                noResultSubtitle: 'សូមព្យាយាមប្រើពាក្យគន្លឹះផ្សេង',
                buildResultItem: (notif) =>
                    _NotificationResultCard(notification: notif),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _NotificationResultCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationResultCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: notification.isRead ? AppColors.backgroundGrey : AppColors.lightBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              notification.computedIcon,
              color: notification.isRead ? AppColors.grey : AppColors.darkBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notification.title,
                  style: AppTextStyles.subtitle3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: AppTextStyles.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${notification.date}  •  ${notification.time}',
                  style: AppTextStyles.caption2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (!notification.isRead)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.darkBlue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
