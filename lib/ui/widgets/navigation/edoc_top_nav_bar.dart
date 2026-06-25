import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class TopNavBarWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onSearchTap;

  const TopNavBarWidget({
    super.key,
    required this.title,
    this.onBackTap,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 80,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: onBackTap,
                splashRadius: 24,
              ),
            ),
            
            const SizedBox(width: 26),

            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: AppTextStyles.title2.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (onSearchTap != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, size: 24),
                  onPressed: onSearchTap,
                  splashRadius: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}