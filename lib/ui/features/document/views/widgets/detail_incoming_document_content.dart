import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/ui/features/document/controllers/incoming_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Incoming document detail content with workflow, summary, attachments,
/// comment box, and approve/reject/forward action buttons.
class DetailIncomingDocumentContent extends StatelessWidget {
  final DocumentDetailController controller;

  DetailIncomingDocumentContent({
    super.key,
    required this.controller,
  });

  IncomingDocumentController get _incomingCtrl =>
      Get.put(IncomingDocumentController());

  @override
  Widget build(BuildContext context) {
    // Load the document into incoming controller for actions
    final docId = controller.detail.value?.document.id;
    if (docId != null && _incomingCtrl.document.value == null) {
      _incomingCtrl.loadDocument(docId.toString());
    }

    return Obx(() {
      final detail = controller.detail.value;
      if (detail == null) {
        return const Center(
          child: Text('មិនមានទិន្នន័យ',
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        );
      }

      final doc = detail.document;
      final steps = doc.workflowSteps;
      final allApproved = steps.every((s) => s.isApproved);
      final anyRejected = steps.any((s) => s.isRejected);
      final canAct = !allApproved && !anyRejected;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── 1. Workflow Step Flow ──
            _buildWorkflowSection(detail, steps),

            const SizedBox(height: 16),

            // ── 2. Summary Card ──
            _buildSummaryCard(detail),

            const SizedBox(height: 16),

            // ── 3. Attachment Card ──
            _buildAttachmentCard(detail),

            const SizedBox(height: 16),

            // ── 4. Comment Card ──
            _buildCommentCard(),

            const SizedBox(height: 16),

            // ── 5. Action Buttons (only if can act) ──
            if (canAct) ...[
              Obx(() => ButtonWidget(
                    text: 'អនុម័តឯកសារ',
                    icon: Icons.check_circle_outline,
                    width: double.infinity,
                    backgroundColor: Colors.green,
                    isLoading: _incomingCtrl.isActionLoading.value,
                    onPressed: _incomingCtrl.isActionLoading.value
                        ? null
                        : () async {
                            await _incomingCtrl.approveCurrentStep();
                            // Refresh detail data
                            controller.loadDocument(doc.id.toString());
                          },
                  )),
              const SizedBox(height: 12),
              Obx(() => ButtonWidget(
                    text: 'បដិសេធឯកសារ',
                    width: double.infinity,
                    icon: Icons.cancel_outlined,
                    backgroundColor: Colors.red,
                    isLoading: _incomingCtrl.isActionLoading.value,
                    onPressed: _incomingCtrl.isActionLoading.value
                        ? null
                        : () async {
                            await _incomingCtrl.rejectCurrentStep();
                            controller.loadDocument(doc.id.toString());
                          },
                  )),
              const SizedBox(height: 12),
              ButtonWidget(
                text: 'ផ្ញើបន្តឯកសារ',
                width: double.infinity,
                icon: Icons.edit_outlined,
                backgroundColor: AppColors.darkBlue,
                onPressed: () {
                  Get.snackbar(
                    'ផ្ញើបន្ត',
                    'មុខងារផ្ញើបន្តនឹងមាននៅពេលក្រោយ',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.darkBlue,
                    colorText: Colors.white,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

            // Show completion message when all approved or rejected
            if (allApproved)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF22C55E)),
                    SizedBox(width: 10),
                    Text('ឯកសារនេះត្រូវបានអនុម័តទាំងស្រុង',
                        style: TextStyle(
                            color: Color(0xFF22C55E),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            else if (anyRejected)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cancel, color: Color(0xFFDC2626)),
                    SizedBox(width: 10),
                    Text('ឯកសារនេះត្រូវបានបដិសេធ',
                        style: TextStyle(
                            color: Color(0xFFDC2626),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  // ─── 1. WORKFLOW SECTION ───────────────────────────────────────────────

  Widget _buildWorkflowSection(dynamic detail, List<dynamic> steps) {
    final doc = detail.document;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Document Header ──
          Text(doc.titleKhmer,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.tag, size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text('លេខលិខិត: ${doc.documentNumber}',
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF64748B))),
              const SizedBox(width: 20),
              const Icon(Icons.calendar_today_outlined,
                  size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(doc.date.isNotEmpty ? doc.date : doc.createdAt,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 14),
          // Status badge
          _buildStatusBadge(doc),
          const SizedBox(height: 24),

          // ── Section title ──
          const Text('ព័ត៌មានលំហូរ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),

          // ── Horizontal Flow Line ──
          if (steps.isEmpty)
            const Center(
              child: Text('មិនមានព័ត៌មានលំហូរ',
                  style: TextStyle(color: Colors.grey)),
            )
          else
            _buildFlowLine(steps),
        ],
      ),
    );
  }

  Widget _buildFlowLine(List<dynamic> steps) {
    const double circleSize = 42;
    const double lineWidth = 40;
    const double lineThickness = 3;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top row: circles connected by lines ──
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < steps.length; i++) ...[
                  _buildFlowCircle(steps[i], i),
                  if (i < steps.length - 1)
                    _buildFlowConnector(steps[i], steps[i + 1],
                        lineWidth, lineThickness),
                ],
              ],
            ),
            const SizedBox(height: 8),
            // ── Bottom row: labels centered under each circle ──
            Row(
              mainAxisSize: MainAxisSize.min,
              children: steps.asMap().entries.map((entry) {
                final i = entry.key;
                final isLast = i == steps.length - 1;
                return SizedBox(
                  width: circleSize + (isLast ? 0 : lineWidth),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: circleSize,
                      child: Column(
                        children: [
                          Text(
                            entry.value.level.isNotEmpty
                                ? entry.value.level
                                : 'ជំហាន ${entry.value.stepNumber}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.value.isApproved
                                ? 'បានអនុម័ត'
                                : entry.value.isRejected
                                    ? 'បានបដិសេធ'
                                    : 'កំពុងរង់ចាំ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: entry.value.isApproved
                                  ? const Color(0xFF22C55E)
                                  : entry.value.isRejected
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowCircle(dynamic step, int index) {
    final Color bgColor = step.isApproved
        ? const Color(0xFF22C55E)
        : step.isRejected
            ? const Color(0xFFDC2626)
            : const Color(0xFF4F46E5);

    final Widget child = step.isApproved
        ? const Icon(Icons.check, color: Colors.white, size: 22)
        : step.isRejected
            ? const Icon(Icons.close, color: Colors.white, size: 22)
            : Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _buildFlowConnector(
      dynamic currentStep, dynamic nextStep, double width, double thickness) {
    final Color color;
    if (currentStep.isRejected) {
      color = const Color(0xFFDC2626);
    } else if (currentStep.isApproved && nextStep.isApproved) {
      color = const Color(0xFF22C55E);
    } else {
      color = Colors.grey.shade300;
    }

    return Container(
      height: thickness,
      width: width,
      color: color,
    );
  }

  Widget _buildStatusBadge(dynamic doc) {
    final status = DocumentStatusX.fromString(doc.status);
    final colors = status.colors;
    return Container(
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
          Text(status.khmerTitle,
              style: TextStyle(
                  color: colors['text'], fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ─── 2. SUMMARY CARD ──────────────────────────────────────────────────

  Widget _buildSummaryCard(dynamic detail) {
    final doc = detail.document;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('សង្ខេប',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Text(
            doc.subject.isNotEmpty ? doc.subject : 'មិនមានការពិពណ៌នា',
            style: TextStyle(height: 1.7, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),

          // Row 1: Program + Creator
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
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.person_outline,
                  color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail.creatorName,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Text('អ្នកបង្កើត',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 2: Files + Date
          Row(
            children: [
              Icon(Icons.description_outlined,
                  size: 18, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text('${detail.attachedFiles.length} file(s)',
                  style: TextStyle(color: Colors.grey.shade700)),
              const Spacer(),
              Icon(Icons.calendar_today_outlined,
                  size: 18, color: Colors.grey.shade500),
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

  // ─── 3. ATTACHMENT CARD ──────────────────────────────────────────────

  Widget _buildAttachmentCard(dynamic detail) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ឯកសារ និងឯកសារភ្ជាប់',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 18),
          if (detail.attachedFiles.isEmpty)
            const Center(
              child: Text('មិនមានឯកសារភ្ជាប់',
                  style: TextStyle(color: Colors.grey)),
            )
          else
            ...detail.attachedFiles.asMap().entries.map((e) => Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          e.key == detail.attachedFiles.length - 1 ? 0 : 12),
                  child: _fileTile(e.value),
                )),
        ],
      ),
    );
  }

  Widget _fileTile(String fileName) {
    final meta = _fileIconMeta(fileName);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(meta.icon, color: meta.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(meta.label,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.snackbar('ទាញយកឯកសារ', 'កំពុងទាញយក: $fileName',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.darkBlue,
                  colorText: Colors.white);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.download_outlined, color: AppColors.darkBlue),
            ),
          ),
        ],
      ),
    );
  }

  _FileIcon _fileIconMeta(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return _FileIcon(Icons.picture_as_pdf, Colors.red, 'PDF Document');
      case 'docx':
      case 'doc':
        return _FileIcon(Icons.description, Colors.blue, 'Word Document');
      case 'xlsx':
      case 'xls':
        return _FileIcon(Icons.table_chart, Colors.green, 'Excel Document');
      default:
        return _FileIcon(Icons.insert_drive_file, Colors.grey, 'Unknown');
    }
  }

  // ─── 4. COMMENT CARD ──────────────────────────────────────────────────

  final _commentController = TextEditingController();

  Widget _buildCommentCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ចំណាំ :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'សរសេរចំណាំនៅទីនេះ...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// File icon metadata helper.
class _FileIcon {
  final IconData icon;
  final Color color;
  final String label;
  const _FileIcon(this.icon, this.color, this.label);
}
