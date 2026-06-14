import 'package:flutter/material.dart';

class SearchHistoryTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SearchHistoryTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFE9ECEF), // Circular background gray
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.history,
          color: Colors.grey,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black54, // Soft dark color matching your design
          fontSize: 15,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // Safe text scaling for long names
      ),
    );
  }
}