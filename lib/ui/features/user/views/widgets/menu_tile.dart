import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  const MenuTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.iconColor = const Color(0xFF6E7887), // Muted slate gray from design
    this.textColor = const Color(0xFF1A1A1A), // Clean near-black title text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
            child: Row(
              children: [
                // 1. Leading Feature Icon
                Icon(
                  leadingIcon,
                  color: iconColor,
                  size: 22,
                ),
                const SizedBox(width: 16),
                
                // 2. Main Title Text Label
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                
                // 3. Trailing Chevron Arrow
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF8A92A6), // Soft gray chevron tint
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