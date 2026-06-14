import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/data/models/document/detail_document_model.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/document_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Content widget for the detail document screen.
/// Displays document info, attachments, workflow, and history.
/// Data is injected via [DetailDocumentController].
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
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.grey),
                const SizedBox(height: 16),
                Text('មានបញ្ហា: $error',
                    style: AppTextStyles.body3,
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadDocument(
                      controller.detail.value?.document.id ?? ''),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainInfoCard(detail),
            const SizedBox(height: 16),
            _buildDocumentInfoCard(detail),
            const SizedBox(height: 16),
            _buildFileAttachments(detail),
            const SizedBox(height: 16),
            _buildApprovalWorkflow(detail),
            const SizedBox(height: 16),
            _buildHistorySection(detail),
          ],
        ),
      );
    });
  }

  // ─── Section 1: Main Information Card ─────────────────────────────────

  Widget _buildMainInfoCard(DetailDocumentModel detail) {
    final doc = detail.document;
    final status = DocumentStatusX.fromString(doc.status);
    final colors = status.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(doc.titleKhmer,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors['bg'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(status.icon, size: 14, color: colors['icon']),
                    const SizedBox(width: 4),
                    Text(status.khmerTitle,
                        style: TextStyle(
                            fontSize: 12, color: colors['text'])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(doc.subject.isNotEmpty ? doc.subject : 'គ្មានកម្មវត្ថុ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _metadataItem(
                  Icons.account_balance_outlined,
                  doc.program.isNotEmpty ? doc.program : 'មិនមាន',
                  'អង្គភាព',
                ),
              ),
              Expanded(
                child: _metadataItem(
                  Icons.person_outline,
                  detail.creatorName,
                  'បង្កើតដោយ',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _metadataItem(
            Icons.calendar_today_outlined,
            doc.date.isNotEmpty ? doc.date : doc.createdAt,
            'កាលបរិច្ឆេទ',
          ),
        ],
      ),
    );
  }

  // ─── Section 2: Document Information ───────────────────────────────────

  Widget _buildDocumentInfoCard(DetailDocumentModel detail) {
    final doc = detail.document;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ព័ត៌មានឯកសារ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _metadataItem(
                  Icons.tag,
                  'លេខ: ${doc.documentNumber}',
                  'លេខលិខិត',
                ),
              ),
              Expanded(
                child: _metadataItem(
                  Icons.description_outlined,
                  doc.subject.isNotEmpty ? doc.subject : 'មិនមាន',
                  'កម្មវត្ថុ',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _metadataItem(
                  Icons.account_balance_outlined,
                  doc.program.isNotEmpty ? doc.program : 'មិនមាន',
                  'អង្គភាព',
                ),
              ),
              Expanded(
                child: _metadataItem(
                  Icons.person_outline,
                  detail.creatorName,
                  'ឈ្មោះអ្នកប្រើប្រាស់',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _metadataItem(
                  Icons.calendar_today_outlined,
                  doc.date.isNotEmpty ? doc.date : doc.createdAt,
                  'ថ្ងៃបង្កើត',
                ),
              ),
              Expanded(
                child: _metadataItem(
                  Icons.file_copy_outlined,
                  '${detail.attachedFiles.length} ឯកសារ',
                  'ឯកសារសរុប',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Section 3: File Attachments ───────────────────────────────────────

  Widget _buildFileAttachments(DetailDocumentModel detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ឯកសារ និងឯកសារភ្ជាប់',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (detail.attachedFiles.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text('មិនមានឯកសារភ្ជាប់',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...detail.attachedFiles.map((file) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildFileItem(file),
                )),
        ],
      ),
    );
  }

  Widget _buildFileItem(String fileName) {
    final icon = _getFileIcon(fileName);
    final fileType = _getFileType(fileName);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon['icon'] as IconData, color: icon['color'] as Color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(fileType,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined, color: AppColors.grey),
            onPressed: () => _showPreview(fileName),
            tooltip: 'មើល',
          ),
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.grey),
            onPressed: () => _onDownload(fileName),
            tooltip: 'ទាញយក',
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return {'icon': Icons.picture_as_pdf, 'color': Colors.red};
      case 'docx':
      case 'doc':
        return {'icon': Icons.description, 'color': Colors.blue};
      case 'xlsx':
      case 'xls':
        return {'icon': Icons.table_chart, 'color': Colors.green};
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return {'icon': Icons.image, 'color': Colors.purple};
      default:
        return {'icon': Icons.insert_drive_file, 'color': Colors.grey};
    }
  }

  String _getFileType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'PDF Document';
      case 'docx':
      case 'doc':
        return 'Word Document';
      case 'xlsx':
      case 'xls':
        return 'Excel Document';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'Image';
      default:
        return 'Unknown';
    }
  }

  void _showPreview(String fileName) {
    Get.snackbar('មើលឯកសារ', 'កំពុងបើក: $fileName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.darkBlue,
        colorText: Colors.white);
  }

  void _onDownload(String fileName) {
    Get.snackbar('ទាញយកឯកសារ', 'កំពុងទាញយក: $fileName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.darkBlue,
        colorText: Colors.white);
  }

  // ─── Section 4: Approval Workflow ──────────────────────────────────────

  Widget _buildApprovalWorkflow(DetailDocumentModel detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('លំហូរអនុម័ត',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(detail.workflowName,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text('ចំនួនជំហានសរុប: ${detail.totalSteps}',
              style: const TextStyle(fontSize: 13, color: AppColors.grey)),
          const SizedBox(height: 16),
          ...List.generate(detail.approvalSteps.length, (index) {
            final step = detail.approvalSteps[index];
            final isLast = index == detail.approvalSteps.length - 1;
            final stepStatus =
                index == 0 ? 'កំពុងរង់ចាំ' : 'មិនទាន់ចាប់ផ្តើម';
            final statusColor =
                index == 0 ? const Color(0xFFF59E0B) : AppColors.grey;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == 0
                                  ? AppColors.darkBlue
                                  : Colors.grey.shade300,
                            ),
                            child: Center(
                              child: Text('${step.stepNumber}',
                                  style: TextStyle(
                                    color: index == 0
                                        ? Colors.white
                                        : AppColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  )),
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                  width: 2,
                                  color: Colors.grey.shade300),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(step.level,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text(step.flowLevel,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.grey)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    statusColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                stepStatus,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: statusColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Section 5: History ────────────────────────────────────────────────

  Widget _buildHistorySection(DetailDocumentModel detail) {
    final doc = detail.document;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ប្រវត្តិ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _metadataItem(Icons.person_outline, detail.creatorName, 'បង្កើតដោយ'),
          const SizedBox(height: 12),
          _metadataItem(
              Icons.calendar_today_outlined, doc.createdAt, 'ថ្ងៃបង្កើត'),
          const SizedBox(height: 12),
          _metadataItem(Icons.update, doc.createdAt, 'កែប្រែចុងក្រោយ'),
        ],
      ),
    );
  }

  // ─── Shared Widget ─────────────────────────────────────────────────────

  Widget _metadataItem(IconData icon, String text, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
