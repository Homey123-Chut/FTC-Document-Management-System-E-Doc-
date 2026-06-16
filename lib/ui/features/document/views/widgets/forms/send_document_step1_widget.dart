import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/inputs/edoc_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Step 1 of Send Document: select a created document.
/// Visual design matches sent_document_step1_form.dart.
class SendDocumentStep1Widget extends StatelessWidget {
  final SendDocumentController controller;

  const SendDocumentStep1Widget({super.key, required this.controller});

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

        // ── Form Content ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: Column(
            children: [
              _buildStepHeader(),
              const SizedBox(height: 24),

              // Dropdown: document title
              Obx(() => DropdownField(
                    label: 'ចំណងជើងឯកសារ *',
                    value: controller.selectedStep1Item.value,
                    items: controller.step1DisplayItems.toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.onStep1ItemSelected(val);
                      }
                    },
                    dropdownLabel: 'សូមជ្រើសរើសឯកសារ',
                  )),

              const SizedBox(height: 32),

              // ── Buttons ──
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: AppColors.grey),
                        ),
                        child: Text('លុប',
                            style: TextStyle(color: AppColors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: Obx(() => ElevatedButton(
                            onPressed: controller.isStep1Valid.value
                                ? () => controller.nextStep()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkBlue,
                              disabledBackgroundColor:
                                  AppColors.darkBlue.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('បន្ត',
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
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
          _buildStepItem('ជំហានទី ១', AppColors.darkBlue, Colors.white,
              isFirst: true),
          _buildStepItem(
              'ជំហានទី ២', const Color(0xFFE8EAF6), const Color(0xFF757575)),
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