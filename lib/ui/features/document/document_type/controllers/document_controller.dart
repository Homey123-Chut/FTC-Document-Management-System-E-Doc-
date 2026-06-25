import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/ui/features/document/document_type/controllers/create_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/document_type/repositories_impl/document_repository_impl.dart';
import 'package:e_doc_redo/ui/features/document/document_type/services/document_service.dart';
import 'package:e_doc_redo/ui/features/document/document_type/views/widgets/forms/document_create_form.dart';
import 'package:e_doc_redo/ui/features/document/incoming_document/controllers/incoming_document_controller.dart';
import 'package:e_doc_redo/ui/features/document/incoming_document/views/review_document_screen.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/controllers/document_detail_controller.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/detail_outgoing_document_screen.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/views/widgets/forms/send_document_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentController extends GetxController {
  final DocumentService service;
  final DocumentType type;

  DocumentController({
    required this.type,
    DocumentService? service,
  }) : service = service ?? DocumentService(repository: DocumentRepositoryImpl());

  // ── Reactive state ──────────────────────────────────────────────────

  final documents = <DocumentModel>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;
  final showAllDocuments = false.obs;

  /// Recently created documents with draft/pending status.
  final recentDocuments = <DocumentModel>[].obs;

  /// Documents selected for sending (multi-select mode).
  final selectedDocuments = <DocumentModel>[].obs;

  /// Whether the list is in multi-selection mode.
  final isSelectionMode = false.obs;

  /// Loading flag for send action.
  final isSending = false.obs;

  bool get hasData => documents.isNotEmpty;
  bool get hasSelection => selectedDocuments.isNotEmpty;

  // ── Lifecycle ───────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
    if (type == DocumentType.incoming) {
      loadRecentDocuments();
    }
  }

  // ── Data loading ────────────────────────────────────────────────────

  Future<void> loadDocuments() async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await service.getDocumentsByType(type);
      documents.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads recently created documents (draft/pending) for the incoming
  /// document section.
  Future<void> loadRecentDocuments() async {
    try {
      final recent = await service.getRecentDocuments();
      recentDocuments.assignAll(recent);
    } catch (_) {
      // recent documents are supplementary – don't block the UI
    }
  }

  // ── CRUD ────────────────────────────────────────────────────────────

  Future<void> createDocument(DocumentModel document) async {
    documents.insert(0, document);

    try {
      await service.createDocument(document, type);
      // Also refresh recent documents for incoming view
      if (type == DocumentType.incoming) {
        recentDocuments.insert(0, document);
      }
      // Notify other controllers that may be showing incoming docs
      _refreshIncomingController();
    } catch (e) {
      documents.removeWhere((d) => d.id == document.id);
      error.value = e.toString();
      rethrow;
    }
  }

  // ── Selection / send ────────────────────────────────────────────────

  /// Toggles [doc] in or out of the [selectedDocuments] list.
  void toggleSelection(DocumentModel doc) {
    if (!isSelectionMode.value) {
      isSelectionMode.value = true;
    }

    final idx = selectedDocuments.indexWhere((d) => d.id == doc.id);
    if (idx != -1) {
      selectedDocuments.removeAt(idx);
    } else {
      selectedDocuments.add(doc);
    }

    // Exit selection mode when nothing is selected
    if (selectedDocuments.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  /// Returns `true` when [doc] is currently selected.
  bool isSelected(DocumentModel doc) {
    return selectedDocuments.any((d) => d.id == doc.id);
  }

  /// Sends all selected documents.
  /// Changes status from draft → sent, clears selection, and refreshes.
  Future<void> sendSelectedDocuments() async {
    if (selectedDocuments.isEmpty) return;

    isSending.value = true;

    try {
      final ids = selectedDocuments.map((d) => d.id).toList();
      await service.sendDocuments(ids);

      // Update local list statuses
      for (final id in ids) {
        final idx = documents.indexWhere((d) => d.id == id);
        if (idx != -1) {
          documents[idx] = documents[idx].copyWith(status: 'បានផ្ញើ');
        }
      }

      // Clear selection
      selectedDocuments.clear();
      isSelectionMode.value = false;

      // Refresh
      await loadDocuments();
      await loadRecentDocuments();
      _refreshOutgoingController();

      Get.snackbar(
        'ជោគជ័យ',
        'ឯកសារចំនួន ${ids.length} ត្រូវបានបញ្ជូនដោយជោគជ័យ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'មានបញ្ហា',
        'មិនអាចបញ្ជូនឯកសារបានទេ: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  /// Exits selection mode and clears the selection.
  void clearSelection() {
    selectedDocuments.clear();
    isSelectionMode.value = false;
  }

  // ── Navigation helpers ──────────────────────────────────────────────

  /// Navigates to the outgoing-document detail screen for [doc].
  void navigateToOutgoingDetail(DocumentModel doc) {
    Get.delete<DocumentDetailController>();
    final ctrl = Get.put(DocumentDetailController());
    ctrl.loadDocument(doc.id.toString());
    Get.to(() => const DetailDocumentScreen());
  }

  /// Navigates to the incoming-document detail (review) screen for [doc].
  void navigateToIncomingDetail(DocumentModel doc) {
    Get.delete<DocumentDetailController>();
    Get.delete<IncomingDocumentController>();
    final detailCtrl = Get.put(DocumentDetailController());
    detailCtrl.loadDocument(doc.id.toString());
    Get.put(IncomingDocumentController());
    Get.to(() => const DetailIncomingDocumentScreen());
  }

  /// Navigates to the review document screen for a recently created
  /// document (read-only review).
  void navigateToReview(DocumentModel doc) {
    // Reuse the incoming detail screen for read-only review
    navigateToIncomingDetail(doc);
  }

  // ── Dialog helpers ──────────────────────────────────────────────────

  /// Opens the create-document dialog, registering a fresh
  /// [CreateDocumentController] before and cleaning up after.
  void openCreateDialog() {
    // Use force:true so delete silently succeeds even if the controller
    // was never registered (e.g. first time opening the dialog).
    Get.delete<CreateDocumentController>(force: true);
    final createCtrl = Get.put(CreateDocumentController(type: type));
    Get.dialog(
      DocumentCreateForm(controller: createCtrl),
      barrierDismissible: false,
    )
        .then((_) async {
      // Refresh after dialog closes so new docs appear.
      // Run before deleting the controller so loadDocuments doesn't
      // race with a stale widget rebuild.
      await loadDocuments();
      if (type == DocumentType.incoming) {
        await loadRecentDocuments();
      }

      // Delay deletion until the dismiss animation completes.
      // During the animation the form widget may still rebuild;
      // deferring the delete prevents "CreateDocumentController
      // not found" errors.
      Future.delayed(const Duration(milliseconds: 400), () {
        if (Get.isRegistered<CreateDocumentController>()) {
          Get.delete<CreateDocumentController>(force: true);
        }
      });
    });
  }

  /// Opens the send-document dialog.
  void openSendDialog() {
    Get.dialog(const SendDocumentDialog(), barrierDismissible: false);
  }

  // ── Internal helpers ────────────────────────────────────────────────

  /// Notifies the incoming-document controller to refresh its list.
  void _refreshIncomingController() {
    try {
      final ctrl = Get.find<DocumentController>(tag: 'doc_incoming');
      ctrl.loadDocuments();
      ctrl.loadRecentDocuments();
    } catch (_) {
      // Controller not registered yet – fine
    }
  }

  /// Notifies the outgoing-document controller to refresh its list.
  void _refreshOutgoingController() {
    try {
      final ctrl = Get.find<DocumentController>(tag: 'doc_outgoing');
      ctrl.loadDocuments();
    } catch (_) {
      // Controller not registered yet – fine
    }
  }
}
