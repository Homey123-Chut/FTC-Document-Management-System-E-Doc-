import 'package:flutter/material.dart';

/// A card that shows "Show more" to navigate to the all-folders view.
/// Used at the end of a limited folder grid inside [FolderSection].
class ShowMoreFolderCard extends StatelessWidget {
  final VoidCallback onTap;

  const ShowMoreFolderCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F3F5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.apps,
                color: Color(0xFF1565C0),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'បង្ហាញបន្ថែម',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3142),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
