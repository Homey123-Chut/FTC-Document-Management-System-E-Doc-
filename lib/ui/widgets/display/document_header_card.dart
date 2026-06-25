import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';


class DocumentHeaderCard extends StatelessWidget {
  final String title;
  final String documentNumber;
  final String date;
  final VoidCallback? onDownload;
  final Widget? statusWidget;

  const DocumentHeaderCard({
    super.key,
    required this.title,
    required this.documentNumber,
    required this.date,
    this.onDownload,
    this.statusWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle2,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'លេខលិខិត: $documentNumber',
                      style: AppTextStyles.body3,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child:
                          Text('•', style: TextStyle(color: Color(0xFF64748B))),
                    ),
                    Text(
                      date,
                      style: AppTextStyles.body3,
                    ),
                  ],
                ),
                if (statusWidget != null) ...[
                  const SizedBox(height: 10),
                  statusWidget!,
                ],
              ],
            ),
          ),

          if (onDownload != null)
            OutlinedButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download, size: 20),
              label: const Text('ទាញយក'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1E40AF),
                side: const BorderSide(color: Color(0xFF1E40AF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
        ],
      ),
    );
  }
}
