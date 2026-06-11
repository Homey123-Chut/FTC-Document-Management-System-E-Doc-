import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class UploadField extends StatelessWidget {
  final String label;
  final String fileName;
  final VoidCallback onTap;

  const UploadField({
    super.key,
    required this.label,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label2,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBlue, width: 1.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.file_upload_outlined, color: AppColors.darkBlue, size: 28),
                const SizedBox(height: 8),
                Text(
                  fileName,
                  style: AppTextStyles.label2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}