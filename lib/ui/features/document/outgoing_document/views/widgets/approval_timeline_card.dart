import 'package:e_doc_redo/data/models/document/detail_document.dart';
import 'package:flutter/material.dart';

class ApprovalTimelineCard extends StatelessWidget {
  final DetailDocumentModel detail;

  const ApprovalTimelineCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final doc = detail.document;
    final steps = detail.approvalSteps;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 210, 209, 209)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'លំហូរឯកសារ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (steps.isEmpty)
            const Center(
              child: Text('មិនមានព័ត៌មានលំហូរ',
                  style: TextStyle(color: Colors.grey)),
            )
          else
            ...steps.asMap().entries.map((entry) {
              final i = entry.key;
              final step = entry.value;
              final isLast = i == steps.length - 1;

              final bool stepCompleted = step.isApproved;
              final bool stepRejected = step.isRejected;
              final String badgeLabel = stepRejected
                  ? 'បានបដិសេធ'
                  : stepCompleted
                      ? 'បានអនុម័ត'
                      : 'កំពុងរង់ចាំ';
              final Color badgeColor = stepRejected
                  ? const Color(0xFFDC2626)
                  : stepCompleted
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFF59E0B);
              final Color badgeBg = stepRejected
                  ? const Color(0xFFFEF2F2)
                  : stepCompleted
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFFFBEB);

              final department =
                  step.level.isNotEmpty ? step.level : 'មិនស្គាល់';

              return _TimelineItem(
                title: department,
                subtitle: detail.creatorName,
                date: doc.date.isNotEmpty ? doc.date : doc.createdAt,
                description: step.flowLevel.isNotEmpty
                    ? step.flowLevel
                    : detail.workflowName,
                badgeLabel: badgeLabel,
                badgeColor: badgeColor,
                badgeBg: badgeBg,
                isCompleted: stepCompleted || stepRejected,
                isLast: isLast,
              );
            }),
        ],
      ),
    );
  }
}


class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String description;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeBg;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.description,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeBg,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.rectangle,
                ),
                child: Icon(
                  isCompleted
                      ? (badgeLabel.contains('បដិសេធ')
                          ? Icons.cancel
                          : Icons.check_circle)
                      : Icons.schedule,
                  color: badgeColor,
                  size: 24,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(badgeLabel,
                            style: TextStyle(
                              color: badgeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(subtitle,
                          style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(date,
                          style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.arrow_forward,
                          size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(description,
                            style: TextStyle(color: Colors.grey.shade700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
