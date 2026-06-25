import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/send_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/widgets/forms/send_document_step1_widget.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/widgets/forms/send_document_step2_widget.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/widgets/forms/send_document_step3_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 3-step modal dialog for sending an outgoing document.
/// Registers [SendDocumentController] scoped to this dialog.
class SendDocumentDialog extends StatefulWidget {
  const SendDocumentDialog({super.key});

  @override
  State<SendDocumentDialog> createState() => _SendDocumentDialogState();
}

class _SendDocumentDialogState extends State<SendDocumentDialog> {
  late final SendDocumentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SendDocumentController());
  }

  @override
  void dispose() {
    Get.delete<SendDocumentController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Obx(() {
        switch (_controller.currentStep.value) {
          case 0:
            return SendDocumentStep1Widget(
              controller: _controller,
            );
          case 1:
            return SendDocumentStep2Widget(
              controller: _controller,
            );
          case 2:
            return SendDocumentStep3Widget(
              controller: _controller,
              onSubmit: _controller.submitAndNavigate,
            );
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}
