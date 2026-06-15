import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/ui/features/document/incoming_document/services/incoming_document_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for incoming document approval/review actions.
/// Handles approve, reject, and refresh operations.
class IncomingDocumentController extends GetxController {
  final IncomingDocumentService service;

  IncomingDocumentController({IncomingDocumentService? service})
      : service = service ?? IncomingDocumentService();

  /// The document currently being viewed/acted on.
  final document = Rxn<OutgoingDocumentModel>();

  /// Loading flag for approve/reject actions.
  final isActionLoading = false.obs;

  /// The action result message after approve/reject.
  final actionMessage = Rxn<String>();

  /// Whether the action was successful (true) or failed (false).
  final actionSuccess = Rxn<bool>();

  /// Loads a document by ID into the reactive [document].
  Future<void> loadDocument(String id) async {
    final doc = await service.getDocumentById(id);
    document.value = doc;
  }

  /// Approves the current pending step.
  /// Updates [document] reactively and shows a success snackbar.
  Future<bool> approveCurrentStep() async {
    final doc = document.value;
    if (doc == null) return false;

    final pendingStep = service.findCurrentPendingStep(doc.workflowSteps);
    if (pendingStep == null) {
      _showResult(false, 'មិនមានជំហានដែលត្រូវអនុម័តទេ');
      return false;
    }

    isActionLoading.value = true;
    try {
      final updated = await service.approveStep(doc.id);
      document.value = updated;
      _showResult(true, 'ជំហានទី ${pendingStep.stepNumber} (${pendingStep.level}) ត្រូវបានអនុម័តដោយជោគជ័យ');

      // Refresh outgoing document list
      _refreshOutgoingList();
      return true;
    } catch (e) {
      _showResult(false, 'មានបញ្ហា: $e');
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }

  /// Rejects the current pending step.
  Future<bool> rejectCurrentStep({String? comment}) async {
    final doc = document.value;
    if (doc == null) return false;

    final pendingStep = service.findCurrentPendingStep(doc.workflowSteps);
    if (pendingStep == null) {
      _showResult(false, 'មិនមានជំហានដែលត្រូវបដិសេធទេ');
      return false;
    }

    isActionLoading.value = true;
    try {
      final updated = await service.rejectStep(doc.id, comment: comment);
      document.value = updated;
      _showResult(false, 'ជំហានទី ${pendingStep.stepNumber} (${pendingStep.level}) ត្រូវបានបដិសេធ');

      _refreshOutgoingList();
      return true;
    } catch (e) {
      _showResult(false, 'មានបញ្ហា: $e');
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }

  void _showResult(bool success, String message) {
    actionMessage.value = message;
    actionSuccess.value = success;
    Get.snackbar(
      success ? 'ជោគជ័យ' : 'សូមជ្រាប',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? Colors.green : Colors.orange,
      colorText: Colors.white,
    );
  }

  /// Triggers refresh of the outgoing document list so the card status updates.
  void _refreshOutgoingList() {
    try {
      // Use tag-based lookup so no direct import of DocumentController needed.
      // ignore: invalid_use_of_protected_member
      final docCtrl = Get.find(tag: 'doc_outgoing');
      if (docCtrl != null) {
        // Call loadDocuments via dynamic dispatch.
        (docCtrl as dynamic).loadDocuments();
      }
    } catch (_) {
      // Outgoing list controller might not be initialized yet.
    }
  }
}
