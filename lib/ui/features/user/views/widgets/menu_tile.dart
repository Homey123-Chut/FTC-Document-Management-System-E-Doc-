import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;

  const MenuTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.iconColor = const Color(0xFF6E7887), 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.015),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Icon(
                  leadingIcon,
                  color: iconColor,
                  size: 22,
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.label1,
                  ),
                ),
                
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF8A92A6), 
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}