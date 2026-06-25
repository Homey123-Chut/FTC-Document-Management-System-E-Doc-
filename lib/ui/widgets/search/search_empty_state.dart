import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

class SearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;

  const SearchEmptyState({
    super.key,
    this.icon = Icons.search,
    this.title = 'ស្វែងរក',

  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.grey.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.body2, textAlign: TextAlign.center),
            
          ],
        ),
      ),
    );
  }
}
