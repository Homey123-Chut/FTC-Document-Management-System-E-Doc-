import 'package:flutter/material.dart';

class FolderCard extends StatelessWidget {
  final String title;
  final int documentCount;
  final VoidCallback onTap;

  const FolderCard({
    super.key,
    required this.title,
    required this.documentCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Material must be transparent to show Container's decoration
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16), // Ensures ripple matches the border
        child: Container(
          padding: const EdgeInsets.all(16),
          // Your desired decoration here
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.folder, size: 40, color: Colors.amber),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '$documentCount ឯកសារ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}