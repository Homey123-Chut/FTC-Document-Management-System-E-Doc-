import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/action/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/input/edoc_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Step 2 of Send Document: select a workflow template.
/// Visual design matches sent_document_step2_form.dart.
class SendDocumentStep2Widget extends StatelessWidget {
  final SendDocumentController controller;

  const SendDocumentStep2Widget({super.key, required this.controller});

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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // ── Step Header ──
        _buildStepHeader(),

        const SizedBox(height: 24),

        // ── Form Content ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Obx(() => DropdownField(
                    label: 'លំហូរឯកសារ *',
                    value: controller.selectedWorkflowName.value,
                    items: controller.step2WorkflowNames.toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.onWorkflowSelected(val);
                      }
                    },
                    dropdownLabel: 'សូមជ្រើសរើសលំហូរឯកសារ',
                  )),
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
                          text: 'បន្ត',
                          onPressed: controller.isStep2Valid.value
                              ? () => controller.nextStep()
                              : null,
                        )),
                  ),
                ],
              ),
            ],
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
              const Color(0xFF757575),
              isFirst: true),
          _buildStepItem(
              'ជំហានទី ២', AppColors.darkBlue, Colors.white),
          _buildStepItem('ជំហានទី ៣', const Color(0xFFE8EAF6),
              const Color(0xFF757575),
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