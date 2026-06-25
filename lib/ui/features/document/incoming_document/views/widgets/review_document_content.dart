import 'package:e_doc_redo/services/download_service.dart';
import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/incoming_document/controllers/incoming_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/incoming_document/views/widgets/comment_card.dart';
import 'package:e_doc_redo/ui/widgets/display/document_header_card.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_attachment_files_card.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_summary_detail_card.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/display/flow_line_step.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailIncomingDocumentContent extends StatelessWidget {
  final DocumentDetailController controller;

  const DetailIncomingDocumentContent({
    super.key,
    required this.controller,
  });

  IncomingDocumentController get _incomingCtrl => Get.find<IncomingDocumentController>();

  @override
  Widget build(BuildContext context) {
    final docId = controller.detail.value?.document.id;
    if (docId != null && _incomingCtrl.document.value == null) {
      _incomingCtrl.loadDocument(docId.toString());
    }

    return Obx(() {
      final detail = controller.detail.value;
      if (detail == null) {
        return Center(
          child: Text('មិនមានទិន្នន័យ',
              style: AppTextStyles.body2),
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
            DocumentHeaderCard(
              title: doc.titleKhmer,
              documentNumber: doc.documentNumber,
              date: doc.date.isNotEmpty ? doc.date : doc.createdAt,
              onDownload: () {
                for (final file in detail.attachedFiles) {
                  controller.downloadFile(file);
                }
              },
            ),
            const SizedBox(height: 16),

            if (steps.isNotEmpty) ...[
              // Identify the first pending step as "current / review".
              () {
                final currentIdx = steps.indexWhere((s) => s.isPending);
                return FlowLineStep(
                  items: steps,
                  labelBuilder: (s) => s.level,
                  circleColorBuilder: (i) {
                    // Future steps get a white circle.
                    if (currentIdx != -1 && i > currentIdx) return Colors.white;
                    // Approved / current → filled blue.
                    return const Color(0xFF4F46E5);
                  },
                  circleBorderBuilder: (i) {
                    // Future steps get a coloured outline.
                    if (currentIdx != -1 && i > currentIdx) {
                      return Border.all(
                          color: const Color(0xFF4F46E5), width: 2);
                    }
                    return null;
                  },
        
                  iconBuilder: (i) {
                    final s = steps[i];
                    final isBeforeCurrent =
                        currentIdx == -1 || i < currentIdx;

                    // Approved (or before current) → check icon.
                    if (s.isApproved || isBeforeCurrent) {
                      return const Icon(Icons.check,
                          color: Colors.white, size: 22);
                    }
                    // Rejected → X icon.
                    if (s.isRejected) {
                      return const Icon(Icons.close,
                          color: Colors.white, size: 22);
                    }
                    // Current step → white number.
                    if (currentIdx == i) {
                      return Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    }
                    // Future step → blue number.
                    return Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  },
                );
              }(),
            ],

            SummaryDetailCard(detail: detail),

            const SizedBox(height: 16),

            Obx(() => AttachmentCard(
                  attachedFiles: detail.attachedFiles,
                  downloadStatuses:
                      Map<String, DownloadStatus>.from(controller.downloadStatuses),
                  downloadProgress:
                      Map<String, double>.from(controller.downloadProgress),
                  onDownload: controller.downloadFile,
                )),

            const SizedBox(height: 16),

            const CommentCard(),

            const SizedBox(height: 16),

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
                width: double.infinity,
                icon: Icons.edit_outlined,
                text: 'កែប្រែឯកសារ',
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
              const SizedBox(height: 12),
            ],

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
                    SizedBox(width: 14),
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
                    SizedBox(width: 14),
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
}
