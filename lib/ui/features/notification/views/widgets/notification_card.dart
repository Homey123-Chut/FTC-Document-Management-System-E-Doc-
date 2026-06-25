import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String description;
  final IconData icon;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    this.icon = Icons.notifications_active_rounded,
    this.isRead = false,
    this.onTap,
  });

  static const _unreadIconBg = Color(0xFFEDF2F9);
  static const _unreadIconColor = AppColors.lightBlue;
  static const _unreadTitleColor = AppColors.black;

  static const _readIconBg = Color(0xFFF5F5F5);
  static const _readIconColor = AppColors.darkGray;
  static const _readTitleColor = AppColors.grey;

  @override
  Widget build(BuildContext context) {
    final iconBg = isRead ? _readIconBg : _unreadIconBg;
    final iconColorVal = isRead ? _readIconColor : _unreadIconColor;
    final titleColor = isRead ? _readTitleColor : _unreadTitleColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColorVal,
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
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        '$date - $time',
                        style: AppTextStyles.body5.copyWith(
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body3,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}