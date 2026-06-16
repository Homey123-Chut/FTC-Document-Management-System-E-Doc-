import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Step 2 of Send Document: select a workflow template.
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

        // ── Step Header (with White Background) ──
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const SizedBox(
            height: 50,
            child: Row(
              children: [
                _StepArrow(text: 'ជំហានទី ១', color: Color(0xFFD3D8E0), textColor: Color(0xFF757575), isFirst: true),
                _StepArrow(text: 'ជំហានទី ២', color: AppColors.darkBlue, textColor: Colors.white),
                _StepArrow(text: 'ជំហានទី ៣', color: Color(0xFFD3D8E0), textColor: Color(0xFF757575), isLast: true),
              ],
            ),
          ),
        ),

        // ── Form Content ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
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
}

/// Arrow-shaped step indicator used in the step header.
class _StepArrow extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final bool isFirst;
  final bool isLast;

  const _StepArrow({
    required this.text,
    required this.color,
    required this.textColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipPath(
        clipper: _ArrowClipper(isFirst: isFirst, isLast: isLast),
        child: Container(
          color: color,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class _ArrowClipper extends CustomClipper<Path> {
  final bool isFirst;
  final bool isLast;
  const _ArrowClipper({required this.isFirst, required this.isLast});

  @override
  Path getClip(Size size) {
    final double arrowWidth = 15.0;

    final path = Path();
    path.moveTo(isFirst ? 0 : arrowWidth, 0);
    path.lineTo(size.width - arrowWidth, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - arrowWidth, size.height);
    path.lineTo(isFirst ? 0 : arrowWidth, size.height);

    if (!isLast) {
      path.lineTo(arrowWidth * 2, size.height / 2);
    } else {
      path.lineTo(0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
