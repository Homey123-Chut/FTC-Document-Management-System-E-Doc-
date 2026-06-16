import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/detail_document.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/controllers/document_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Detail content for an outgoing document.
/// 4-card layout: Header, Summary, Attachments, Approval Timeline.
class DetailDocumentContent extends StatelessWidget {
  final DocumentDetailController controller;

  const DetailDocumentContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final error = controller.error.value;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (error.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.grey),
                const SizedBox(height: 16),
                Text('មានបញ្ហា: $error',
                    style: AppTextStyles.body3, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadDocument(
                      (controller.detail.value?.document.id ?? 0).toString()),
                  child: const Text('ព្យាយាមម្តងទៀត'),
                ),
              ],
            ),
          ),
        );
      }

      final detail = controller.detail.value;
      if (detail == null) {
        return const Center(
          child: Text('មិនមានទិន្នន័យ',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(detail),
            const SizedBox(height: 8),
            _buildSummaryCard(detail),
            const SizedBox(height: 16),
            _buildAttachmentCard(detail),
            const SizedBox(height: 16),
            _buildApprovalTimeline(detail),
          ],
        ),
      );
    });
  }

  // ─── 1. HEADER CARD ───────────────────────────────────────────────────

  Widget _buildHeaderCard(DetailDocumentModel detail) {
    final doc = detail.document;
    final status = DocumentStatusX.fromString(doc.status);
    final colors = status.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(18),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            doc.titleKhmer,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Document number • Date
          Row(
            children: [
              Text(
                'លេខលិខិត: ${doc.documentNumber}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(width: 10),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                doc.date.isNotEmpty ? doc.date : doc.createdAt,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colors['bg'],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(status.icon, size: 16, color: colors['icon']),
                const SizedBox(width: 6),
                Text(
                  status.khmerTitle,
                  style: TextStyle(
                    color: colors['text'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. SUMMARY CARD ──────────────────────────────────────────────────

  Widget _buildSummaryCard(DetailDocumentModel detail) {
    final doc = detail.document;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromARGB(255, 210, 209, 209)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'កម្មវត្ថុ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Subject / description text
          Text(
            doc.subject.isNotEmpty ? doc.subject : 'មិនមានការពិពណ៌នា',
            style: TextStyle(color: Colors.grey.shade700, height: 1.7),
          ),
          const SizedBox(height: 16),

          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 16),

          // Row 1: Program (left) + Creator (right)
          Row(
            children: [
              Icon(Icons.account_balance_outlined,
                  color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.program.isNotEmpty ? doc.program : 'មិនមាន',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Text('អង្គភាព',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),

              Icon(Icons.person_outline,
                  color: Colors.grey.shade500, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail.creatorName,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Text('អ្នកបង្កើត',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: File count (left) + Date (right)
          Row(
            children: [
              Icon(Icons.insert_drive_file_outlined,
                  color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 8),
              Text(
                '${detail.attachedFiles.length} file(s)',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const Spacer(),
              Icon(Icons.calendar_today_outlined,
                  color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 8),
              Text(
                doc.date.isNotEmpty ? doc.date : doc.createdAt,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── 3. ATTACHMENT CARD ───────────────────────────────────────────────

  Widget _buildAttachmentCard(DetailDocumentModel detail) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromARGB(255, 210, 209, 209)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ឯកសារ និងឯកសារភ្ជាប់',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 18),
          if (detail.attachedFiles.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('មិនមានឯកសារភ្ជាប់',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...detail.attachedFiles.asMap().entries.map(
                  (entry) => Padding(
                    padding:
                        EdgeInsets.only(bottom: entry.key == detail.attachedFiles.length - 1 ? 0 : 12),
                    child: _fileItem(entry.value),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _fileItem(String fileName) {
    final meta = _fileMeta(fileName);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // File icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(meta.icon, color: meta.color),
          ),
          const SizedBox(width: 14),

          // File name + type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(meta.label,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),

          // Download button
          GestureDetector(
            onTap: () => _onDownloadFile(fileName),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.download_outlined, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  _FileMeta _fileMeta(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return _FileMeta(Icons.picture_as_pdf, Colors.red, 'PDF Document');
      case 'docx':
      case 'doc':
        return _FileMeta(Icons.description, Colors.blue, 'Word Document');
      case 'xlsx':
      case 'xls':
        return _FileMeta(Icons.table_chart, Colors.green, 'Excel Document');
      case 'jpg':
      case 'jpeg':
      case 'png':
        return _FileMeta(Icons.image, Colors.purple, 'Image');
      default:
        return _FileMeta(
            Icons.insert_drive_file, Colors.grey, 'Unknown');
    }
  }

  void _onDownloadFile(String fileName) {
    Get.snackbar('ទាញយកឯកសារ', 'កំពុងទាញយក: $fileName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.darkBlue,
        colorText: Colors.white);
  }

  // ─── 4. APPROVAL TIMELINE CARD ────────────────────────────────────────

  Widget _buildApprovalTimeline(DetailDocumentModel detail) {
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
            'ព័ត៌មានលំហូរ',
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

              // Read per-step status from model
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

              final department = step.level.isNotEmpty ? step.level : 'មិនស្គាល់';

              return _timelineItem(
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

  Widget _timelineItem({
    required String title,
    required String subtitle,
    required String date,
    required String description,
    required String badgeLabel,
    required Color badgeColor,
    required Color badgeBg,
    required bool isCompleted,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: circle + line
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted
                      ? (badgeLabel.contains('បដិសេធ')
                          ? Icons.cancel
                          : Icons.check_circle)
                      : Icons.schedule,
                  color: badgeColor,
                  size: 16,
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

          // Right: detail card
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
                  // Title + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(badgeLabel,
                            style: TextStyle(
                              color: badgeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Person
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

                  // Date
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

                  // Forward / action
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

/// Lightweight file metadata holder.
class _FileMeta {
  final IconData icon;
  final Color color;
  final String label;
  const _FileMeta(this.icon, this.color, this.label);
}
