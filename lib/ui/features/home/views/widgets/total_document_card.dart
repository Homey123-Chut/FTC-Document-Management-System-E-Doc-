import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';

class TotalDocumentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const TotalDocumentCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.backgroundColor,
    this.iconColor = AppColors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final double paddingH = cardWidth * 0.12;
        final double paddingV = cardWidth * 0.07;
        final double iconPadding = cardWidth * 0.06;
        final double iconSize = cardWidth * 0.15;
        final double countFontSize = cardWidth * 0.13;
        final double labelFontSize = cardWidth * 0.08;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: paddingH, vertical: paddingV),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(icon, color: iconColor, size: iconSize.clamp(18, 28)),
                ),
                SizedBox(
                    height: paddingV.clamp(4, 10).toDouble()),
                Text(
                  title,
                  style: AppTextStyles.title3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                    height: (paddingV * 0.5).clamp(3, 8).toDouble()),
                Row(
                  children: [
                    Text(
                      '$count',
                      style: AppTextStyles.title5,
                    ),
                    SizedBox(
                        width: (paddingH * 0.3).clamp(4, 8).toDouble()),
                    Text(
                      'ឯកសារ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
