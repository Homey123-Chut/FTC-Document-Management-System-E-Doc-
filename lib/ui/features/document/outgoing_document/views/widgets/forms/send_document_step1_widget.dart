import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/display/step_arrow_header.dart';
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
                    headerLabel: 'គោលដៅ',
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
    return const StepArrowHeader(
      steps: [
        StepArrowData(title: 'ជំហានទី ១', isActive: true),
        StepArrowData(title: 'ជំហានទី ២', isActive: false),
        StepArrowData(title: 'ជំហានទី ៣', isActive: false),
      ],
    );
  }
}