import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/detail_document.dart';
import 'package:flutter/material.dart';

class SummaryDetailCard extends StatelessWidget {
  final DetailDocumentModel detail;
  final String title;
  final bool showDivider;
  final double borderRadius;
  final Border? border;

  const SummaryDetailCard({
    super.key,
    required this.detail,
    this.title = 'កម្មវត្ថុ',
    this.showDivider = false,
    this.borderRadius = 20,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final doc = detail.document;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subtitle1),
          const SizedBox(height: 16),
          Divider(
            color: AppColors.grey.withValues(alpha: 0.3),
            thickness: 1,
          ),
          const SizedBox(height: 12),
          Text(
            'ចំណារ',
            style: AppTextStyles.subtitle2,
          ),
          const SizedBox(height: 16),
          Text(
            doc.subject.isNotEmpty ? doc.subject : 'មិនមានការពិពណ៌នា',
            style: AppTextStyles.caption1,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.account_balance_outlined,
                  color: AppColors.grey, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.program.isNotEmpty ? doc.program : 'មិនមាន',
                      style: AppTextStyles.body4,
                    ),
                    Text('អង្គភាព',
                        style: AppTextStyles.label2),
                  ],
                ),
              ),
              Icon(Icons.person_outline_sharp,
                  color: AppColors.grey, size: 22),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail.creatorName,
                      style: AppTextStyles.body4),
                  Text('អ្នកបង្កើត',
                      style: AppTextStyles.label2),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: AppColors.grey, size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${detail.attachedFiles.length} file(s)',
                      style: AppTextStyles.body4,
                    ),
                    Text(
                      'ប្រភេទឯកសារ',
                      style: AppTextStyles.label2,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.calendar_today_outlined,
                color: AppColors.grey, size: 22,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.date.isNotEmpty ? doc.date : doc.createdAt,
                    style: AppTextStyles.body4,
                  ),
                  Text(
                    'កាលបរិច្ឆេទ',
                    style: AppTextStyles.label2,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
