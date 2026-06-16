import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class ButtonWidget extends StatelessWidget {
  
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final Color? borderColor;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 50,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.borderColor,
  });

  @override
Widget build(BuildContext context) {
  final btnBackgroundColor = backgroundColor ?? AppColors.darkBlue;
  final btnForegroundColor = foregroundColor ?? (btnBackgroundColor == const Color.fromARGB(255, 234, 237, 249) ? AppColors.grey : AppColors.white);

  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnBackgroundColor,
        foregroundColor: btnForegroundColor,
        elevation: 0,
        // 1. Remove default padding so you can control it manually
        padding: EdgeInsets.symmetric(horizontal: 12), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: AppColors.white)
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  // 2. Adjust this SizedBox to be smaller (e.g., 2 or 4)
                  const SizedBox(width: 4), 
                ],
                Flexible( // Wrap text in Flexible to prevent overflow inside button
                  child: Text(
                    text,
                    style: AppTextStyles.button1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    ),
  );
}
}