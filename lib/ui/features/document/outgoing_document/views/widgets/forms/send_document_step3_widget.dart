import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/display/step_arrow_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SendDocumentStep3Widget extends StatelessWidget {
  final SendDocumentController controller;
  final Future<void> Function() onSubmit;

  const SendDocumentStep3Widget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: const Row(
            children: [
              Text(
                'បញ្ជូនឯកសារ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // ── Body (scrollable) ──
        Flexible(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Obx(() {
                final isLoading = controller.isLoadingStep3.value;
                final doc = controller.selectedDocument.value;
                final workflow = controller.selectedWorkflow.value;

                if (isLoading || doc == null || workflow == null) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Step Header ──
                    _buildStepHeader(),
                    const SizedBox(height: 24),

                    // ── Document Info ──
                    Text(doc.titleKhmer,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('លេខលិខិត: ${doc.documentNumber}',
                        style: const TextStyle(color: AppColors.grey)),
                    const SizedBox(height: 16),

                    // ── File Row ──
                    if (doc.attachedFile.isNotEmpty) ...[
                      const Text('ឯកសារ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.grey.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf,
                                color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(child: Text(doc.attachedFile)),
                            Icon(Icons.remove_red_eye_outlined,
                                color: AppColors.grey),
                            const SizedBox(width: 12),
                            const Icon(Icons.delete_outline,
                                color: Colors.red),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Subject (full paragraph, no icon) ──
                    const Text('កិច្ចការ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      doc.subject.isNotEmpty ? doc.subject : 'កិច្ចការ',
                      style: const TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetadata(
                              doc.program.isNotEmpty
                                  ? doc.program
                                  : 'អ្នកគ្រប់គ្រង',
                              'ការិយាល័យ',
                              Icons.account_balance_outlined),
                        ),
                        Expanded(
                          child: _buildMetadata(
                              controller.creatorName.value,
                              'បង្កើតដោយ',
                              Icons.person_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildMetadata(
                        doc.date.isNotEmpty ? doc.date : 'កាលបរិច្ឆេទ',
                        'កាលបរិច្ឆេទ',
                        Icons.calendar_today_outlined),
                    const SizedBox(height: 24),

                    // ── Flow Section ──
                    const Text('លំហូរឯកសារ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      workflow.workflowTitleKhmer,
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ចំនួនជំហានសរុប: ${workflow.steps.length}',
                      style:
                          const TextStyle(fontSize: 13, color: AppColors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildFlowLine(workflow.steps),
                    const SizedBox(height: 32),

                    // ── Buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => controller.previousStep(),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                side: const BorderSide(color: AppColors.grey),
                              ),
                              child: const Text('ត្រលប់ក្រោយ',
                                  style: TextStyle(color: AppColors.grey)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(() => ButtonWidget(
                                text: 'បញ្ជូន',
                                isLoading: controller.isSubmitting.value,
                                onPressed: controller.isSubmitting.value
                                    ? null
                                    : () => onSubmit(),
                              )),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepHeader() {
    return const StepArrowHeader(
      steps: [
        StepArrowData(title: 'ជំហានទី ១', isActive: false),
        StepArrowData(title: 'ជំហានទី ២', isActive: false),
        StepArrowData(title: 'ជំហានទី ៣', isActive: true),
      ],
    );
  }

  Widget _buildMetadata(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.grey, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.grey)),
          ],
        )
      ],
    );
  }


  Widget _buildFlowLine(List steps) {
    const double circleSize = 52;
    const double lineWidth = 40;
    const double lineThickness = 3;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top row: circles connected by lines, flush — no gaps ──
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < steps.length; i++) ...[
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F46E5),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (i < steps.length - 1)
                    Container(
                      height: lineThickness,
                      width: lineWidth,
                      color: Color(0xFF4F46E5),
                    ),
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
                      child: Text(
                        entry.value.level,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                        ),
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
}

