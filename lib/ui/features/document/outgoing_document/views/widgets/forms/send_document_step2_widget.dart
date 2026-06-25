import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:e_doc_redo/ui/widgets/display/step_arrow_header.dart';
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
          child: const StepArrowHeader(
            inactiveColor: Color(0xFFD3D8E0),
            steps: [
              StepArrowData(title: 'ជំហានទី ១', isActive: false),
              StepArrowData(title: 'ជំហានទី ២', isActive: true),
              StepArrowData(title: 'ជំហានទី ៣', isActive: false),
            ],
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

