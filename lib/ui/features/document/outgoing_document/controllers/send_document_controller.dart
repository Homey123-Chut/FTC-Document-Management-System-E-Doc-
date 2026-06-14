import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/document_reference_model.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/services/send_document_service.dart';
import 'package:e_doc_redo/ui/features/auth/login/services/auth_service.dart';
import 'package:get/get.dart';

/// Controller for the 3-step Send Document flow.
/// Manages step index, selected document, selected workflow, and submission.
class SendDocumentController extends GetxController {
  final SendDocumentService service;

  SendDocumentController({SendDocumentService? service})
      : service = service ?? SendDocumentService();

  // ── Step tracking ──
  final currentStep = 0.obs; // 0, 1, 2

  // ── Step 1 state ──
  final allDocumentRefs = <DocumentReferenceModel>[].obs;
  final allDocuments = <DocumentModel>[].obs; // full model data
  final step1DisplayItems = <String>[].obs; // dropdown display strings
  final selectedStep1Item = ''.obs;
  final selectedDocument = Rxn<DocumentModel>();

  // ── Step 2 state ──
  final workflows = <ApprovalWorkflowModel>[].obs;
  final step2WorkflowNames = <String>[].obs; // dropdown items
  final selectedWorkflowName = ''.obs;
  final selectedWorkflow = Rxn<ApprovalWorkflowModel>();

  // ── Step valid flags ──
  final isStep1Valid = false.obs;
  final isStep2Valid = false.obs;

  // ── Submit ──
  final isSubmitting = false.obs;
  final isLoadingStep3 = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStep1Data();
  }

  /// Loads all created documents from personal/general/incoming for Step 1.
  Future<void> loadStep1Data() async {
    try {
      final refs = await service.fetchAllCreatedDocuments();
      allDocumentRefs.assignAll(refs);
      step1DisplayItems.assignAll(
        refs.map((r) => r.displayText).toList(),
      );
      // Also store full DocumentModel list for later lookups
      final fullDocs = await service.fetchAllDocumentsFull();
      allDocuments.assignAll(fullDocs);
    } catch (_) {
      step1DisplayItems.assignAll([]);
    }
  }

  /// Called when the user selects a display item in the Step 1 dropdown.
  void onStep1ItemSelected(String displayText) {
    selectedStep1Item.value = displayText;

    final matched = allDocumentRefs.firstWhereOrNull(
      (r) => r.displayText == displayText,
    );
    if (matched != null) {
      // Look up the FULL DocumentModel from allDocuments to get all fields
      final fullDoc = allDocuments.firstWhereOrNull((d) => d.id == matched.id);
      selectedDocument.value = fullDoc ?? DocumentModel(
        id: matched.id,
        titleKhmer: matched.titleKhmer,
        titleLatin: '',
        documentNumber: matched.documentNumber,
        date: '',
        status: '',
        subject: '',
        program: '',
        documentHistory: '',
        attachedFile: '',
      );
      isStep1Valid.value = true;
    } else {
      selectedDocument.value = null;
      isStep1Valid.value = false;
    }
  }

  /// Loads workflow templates for Step 2.
  Future<void> loadStep2Data() async {
    try {
      final allWorkflows = await service.fetchWorkflowTemplates();
      workflows.assignAll(allWorkflows);
      step2WorkflowNames.assignAll(
        allWorkflows.map((w) => w.workflowTitleKhmer).toList(),
      );
    } catch (_) {
      step2WorkflowNames.assignAll([]);
    }
  }

  /// Called when the user selects a workflow name in the Step 2 dropdown.
  void onWorkflowSelected(String name) {
    selectedWorkflowName.value = name;

    final matched = workflows.firstWhereOrNull(
      (w) => w.workflowTitleKhmer == name,
    );
    if (matched != null) {
      selectedWorkflow.value = matched;
      isStep2Valid.value = true;
    } else {
      selectedWorkflow.value = null;
      isStep2Valid.value = false;
    }
  }

  /// Advances to the next step. Loads Step 2 data when entering step 1→2.
  void nextStep() {
    if (currentStep.value == 0 && !isStep1Valid.value) return;
    if (currentStep.value == 1 && !isStep2Valid.value) return;

    if (currentStep.value < 2) {
      currentStep.value++;
      if (currentStep.value == 1) {
        loadStep2Data();
      }
    }
  }

  /// Goes back to the previous step.
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  /// Submits the outgoing document.
  /// Builds an [OutgoingDocumentModel] and persists it.
  /// Returns the saved model on success, or null on failure.
  Future<OutgoingDocumentModel?> submit() async {
    if (selectedDocument.value == null || selectedWorkflow.value == null) {
      return null;
    }

    isSubmitting.value = true;

    try {
      final doc = selectedDocument.value!;
      final workflow = selectedWorkflow.value!;

      // Get current user from AuthService
      String createdBy = '';
      try {
        final auth = Get.find<AuthService>();
        createdBy = auth.currentUser?.id ?? '';
      } catch (_) {
        createdBy = '1'; // fallback to first user
      }

      final outgoing = OutgoingDocumentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sourceDocumentId: doc.id,
        documentNumber: doc.documentNumber,
        titleKhmer: doc.titleKhmer,
        titleLatin: doc.titleLatin,
        date: doc.date,
        subject: doc.subject,
        program: doc.program,
        attachedFile: doc.attachedFile,
        workflowTemplateId: workflow.id,
        workflowTemplateName: workflow.workflowTitleKhmer,
        totalSteps: workflow.steps.length,
        workflowSteps: List.from(workflow.steps),
        status: 'កំពុងរង់ចាំ',
        createdAt: DateTime.now().toIso8601String(),
        createdBy: createdBy,
      );

      await service.saveOutgoingDocument(outgoing);
      return outgoing;
    } catch (_) {
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Resets all state (used when dialog is disposed).
  void reset() {
    currentStep.value = 0;
    selectedStep1Item.value = '';
    selectedDocument.value = null;
    selectedWorkflowName.value = '';
    selectedWorkflow.value = null;
    isStep1Valid.value = false;
    isStep2Valid.value = false;
    isSubmitting.value = false;
    isLoadingStep3.value = false;
  }
}
