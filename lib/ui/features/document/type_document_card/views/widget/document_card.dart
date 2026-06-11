import 'package:flutter/material.dart';
import '../../../../../../core/theme/theme.dart';

class DocumentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.subtitle3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('$count', style: AppTextStyles.subtitle1),
                const SizedBox(width: 8),
                const Text('ឯកសារ', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
