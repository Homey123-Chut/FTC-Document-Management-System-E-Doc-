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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: AppColors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button1,
                  ),
                ],
              ),
      ),
    );
  }
}