
import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';

class MethodLoginTileWidget extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback? onTap;

  const MethodLoginTileWidget({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), 
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), 
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              icon,
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.label3,
                  children: [
                    TextSpan(text: text),
                    TextSpan(
                      style: AppTextStyles.label3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}