import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/action/edoc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Step 3 of Send Document: review and submit.
/// Visual design matches sent_document_step3_fomr.dart.
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

                    // ── Metadata ──
                    _buildMetadata(
                        doc.subject.isNotEmpty ? doc.subject : 'កិច្ចការ',
                        'កិច្ចការ',
                        Icons.description_outlined),
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
                              'បង្កើតដោយ',
                              'អ្នកប្រើប្រាស់',
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
                          child: ButtonWidget(
                            text: 'ត្រលប់ក្រោយ',
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: AppColors.grey,
                            onPressed: () => controller.previousStep(),
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
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          _buildStepItem('ជំហានទី ១', const Color(0xFFE8EAF6),
              AppColors.grey,
              isFirst: true),
          _buildStepItem('ជំហានទី ២', const Color(0xFFE8EAF6),
              AppColors.grey),
          _buildStepItem('ជំហានទី ៣', AppColors.darkBlue, Colors.white,
              isLast: true),
        ],
      ),
    );
  }

  Widget _buildStepItem(String text, Color color, Color textColor,
      {bool isFirst = false, bool isLast = false}) {
    return Expanded(
      child: ClipPath(
        clipper: _ArrowClipper(isFirst: isFirst, isLast: isLast),
        child: Container(
          color: color,
          alignment: Alignment.center,
          child: Text(text,
              style:
                  TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        ),
      ),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            if (i > 0)
              Container(
                height: 2,
                width: 30,
                color: AppColors.darkBlue,
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.darkBlue,
                  child: Text('${i + 1}',
                      style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[i].level,
                  style: const TextStyle(fontSize: 12, color: AppColors.darkBlue, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ArrowClipper extends CustomClipper<Path> {
  final bool isFirst;
  final bool isLast;
  _ArrowClipper({required this.isFirst, required this.isLast});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(isFirst ? 0 : 15, 0);
    path.lineTo(size.width - 15, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 15, size.height);
    path.lineTo(isFirst ? 0 : 15, size.height);
    if (!isLast) {
      path.lineTo(15 + (isFirst ? -15 : 0), size.height / 2);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}