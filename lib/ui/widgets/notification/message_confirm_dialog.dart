import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color confirmButtonColor;

  const MessageConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    this.icon = Icons.info_outline_rounded,
    this.iconColor = AppColors.darkRed,
    this.iconBackgroundColor = const Color(0xFFFDEBEC),
    this.confirmButtonColor = AppColors.darkRed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle2,
          ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.body4,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: () => Get.back(result: false),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            side: const BorderSide(color: Colors.black12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            cancelText,
            style: AppTextStyles.body4,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Text(
            confirmText,
            style: AppTextStyles.button2,
          ),
        ),
      ],
    );
  }
}