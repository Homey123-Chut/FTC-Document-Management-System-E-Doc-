import 'package:e_doc_redo/services/download_service.dart';
import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/widgets/approval_timeline_card.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_attachment_files_card.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_summary_detail_card.dart';
import 'package:e_doc_redo/ui/widgets/display/document_header_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        return Center(
          child: Text('មិនមានទិន្នន័យ',
              style: AppTextStyles.body2),
        );
      }

      final doc = detail.document;
      final status = DocumentStatusX.fromString(doc.status);
      final colors = status.colors;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── 1. Header Card ────────────────────────────────────────
            DocumentHeaderCard(
              title: doc.titleKhmer,
              documentNumber: doc.documentNumber,
              date: doc.date.isNotEmpty ? doc.date : doc.createdAt,
              statusWidget: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            ),
            const SizedBox(height: 8),
            // ── 2. Summary Card ───────────────────────────────────────
            SummaryDetailCard(
              detail: detail,
              title: 'កម្មវត្ថុ',
              showDivider: true,
              borderRadius: 18,
              border: Border.all(
                  color: const Color.fromARGB(255, 210, 209, 209)),
            ),
            const SizedBox(height: 16),
            // ── 3. Attachment Card — state lives in controller ────────
            Obx(() => AttachmentCard(
              attachedFiles: detail.attachedFiles,
              borderRadius: 18,
              border: Border.all(
                  color: const Color.fromARGB(255, 210, 209, 209)),
              downloadIconColor: Colors.grey,
              downloadStatuses:
                  Map<String, DownloadStatus>.from(controller.downloadStatuses),
              downloadProgress:
                  Map<String, double>.from(controller.downloadProgress),
              onDownload: (fileName) => controller.downloadFile(fileName),
            )),
            // ── 4. Downloaded files section ───────────────────────────
            Obx(() {
              final downloads =
                  Map<String, String>.from(controller.downloadedFiles);
              if (downloads.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _buildDownloadedFilesCard(downloads),
              );
            }),
            const SizedBox(height: 16),
            // ── 5. Approval Timeline ──────────────────────────────────
            ApprovalTimelineCard(detail: detail),
          ],
        ),
      );
    });
  }

  // ─── Downloaded files card (kept internal — specific to this screen) ─────

  Widget _buildDownloadedFilesCard(Map<String, String> downloads) {
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
          Row(
            children: [
              const Icon(Icons.folder_open, size: 20, color: AppColors.green),
              const SizedBox(width: 8),
              const Text(
                'ឯកសារដែលបានទាញយក',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...downloads.entries.map((entry) => Padding(
                padding: EdgeInsets.only(
                    bottom: entry.key == downloads.keys.last ? 0 : 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.green.withValues(alpha: 0.05),
                    border: Border.all(
                        color: AppColors.green.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.check_circle,
                            color: AppColors.green, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key, style: AppTextStyles.body3),
                            Text(entry.value,
                                style: AppTextStyles.caption2.copyWith(
                                  color: Colors.grey.shade500,
                                  fontSize: 10,
                                )),
                          ],
                        ),
                      ),
                      Icon(Icons.open_in_new,
                          size: 18, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
