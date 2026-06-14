# Send Document Flow & Detail Document Screen — Revised Plan

## Context

The Flutter app (GetX + MVC) has 4 document types. Personal/General/Incoming use "Create Document" → `document_create_form.dart` → saves to `documents.json`. Outgoing needs a "Send Document" 3-step flow that references created documents + workflow templates, then a detail screen to view the result.

**Constraint**: Existing UI files (`sent_document_step1_form.dart`, `sent_document_step2_form.dart`, `sent_document_step3_fomr.dart`, `detail_document_content.dart`) must NOT be modified. Create new controller-aware step widgets that match the same visual design.

---

## Architecture — Strict Layered Chain

```
UI (Step Widgets)
  ↓ Get.find()
Controller (GetxController, .obs)
  ↓ constructor injection
Service (pure Dart)
  ↓ constructor injection
Repository (abstract interface)
  ↓ implements
Mock Repo Impl (rootBundle.loadString, in-memory cache)
  ↓ reads
Mock Data JSON
```

---

## Data Source Mapping

| Data Needed | Source JSON | Repository | Service |
|---|---|---|---|
| Created document titles (Step 1 dropdown) | `documents.json` (ALL types) | `DocumentRepository` | `DocumentService` |
| Workflow template names (Step 2 dropdown) | `approval_workflow.json` + `level_workflow.json` | `WorkflowApprovalRepository` + `LevelWorkflowRepository` | `WorkflowApprovalService` + `LevelWorkflowService` |
| Sent outgoing documents | `outgoing_documents.json` (new) | `SendDocumentRepository` | `SendDocumentService` |
| Detail document (combined) | All 4 JSONs | `DocumentDetailRepository` | `DocumentDetailService` |

---

## New Files (20 files)

### MODELS (3 new)

#### `lib/data/models/document/outgoing_document_model.dart`
```dart
class OutgoingDocumentModel {
  final String id;              // DateTime.now().msSinceEpoch.toString()
  final int sourceDocumentId;   // ref to DocumentModel.id
  final String documentNumber;  // from source document
  final String titleKhmer;      // from source document
  final String titleLatin;      // from source document
  final String date;            // from source document
  final String subject;         // from source document
  final String program;         // from source document
  final String attachedFile;    // from source document
  final String workflowTemplateId;     // from selected workflow
  final String workflowTemplateName;   // from selected workflow
  final int totalSteps;                // workflow.steps.length
  final List<ApprovalStepModel> workflowSteps; // from selected workflow
  final String status;           // 'កំពុងរង់ចាំ'
  final String createdAt;        // ISO string
  final String createdBy;        // user ID from AuthService
  // + fromJson, toJson, copyWith
}
```

#### `lib/data/models/document/document_reference_model.dart`
```dart
class DocumentReferenceModel {
  final int id;
  final String documentNumber;
  final String titleKhmer;
  final String type;  // personal/general/incoming
  // + fromJson
}
```

#### `lib/data/models/document/detail_document_model.dart`
```dart
class DetailDocumentModel {
  final OutgoingDocumentModel document;
  final String creatorName;           // from user.json
  final String creatorDepartment;     // from user.json
  final List<String> attachedFiles;   // from document.attachedFile
  final List<ApprovalStepModel> approvalSteps;
  final String workflowName;
  final int totalSteps;
  // + fromJson
}
```

### MOCK DATA (1 new)

#### `lib/data/mock_data/outgoing_documents.json`
```json
[]
```

### REPOSITORIES — Abstract (2 new)

#### `lib/data/repositories/document/send_document_repository.dart`
```dart
abstract class SendDocumentRepository {
  Future<List<OutgoingDocumentModel>> fetchOutgoingDocuments();
  Future<void> saveOutgoingDocument(OutgoingDocumentModel doc);
  Future<OutgoingDocumentModel?> getOutgoingDocumentById(String id);
}
```

#### `lib/data/repositories/document/document_detail_repository.dart`
```dart
abstract class DocumentDetailRepository {
  Future<OutgoingDocumentModel?> getOutgoingDocumentById(String id);
  Future<List<ApprovalWorkflowModel>> getWorkflows();
  Future<UserModel?> getUserById(String id);
}
```

### REPOSITORIES — Impl (2 new)

#### `lib/ui/features/document/outgoing_document/repositories_impl/send_document_repository_impl.dart`
- Implements `SendDocumentRepository`
- Loads/saves `outgoing_documents.json` via `rootBundle.loadString()` + in-memory cache

#### `lib/ui/features/document/outgoing_document/repositories_impl/document_detail_repository_impl.dart`
- Implements `DocumentDetailRepository`
- Combines data from `outgoing_documents.json` + `approval_workflow.json` + `user.json`

### SERVICES (2 new)

#### `lib/ui/features/document/outgoing_document/services/send_document_service.dart`
```dart
class SendDocumentService {
  final SendDocumentRepository sendDocRepo;
  final DocumentRepository documentRepo;
  final WorkflowApprovalRepository workflowRepo;
  // Constructor: all required, defaults to mock impls
}
```
Methods:
- `Future<List<DocumentReferenceModel>> fetchAllCreatedDocuments()` — reads ALL docs from documents.json (personal + general + incoming), maps to DocumentReferenceModel
- `Future<List<ApprovalWorkflowModel>> fetchWorkflowTemplates()` — reads from approval_workflow.json
- `Future<void> saveOutgoingDocument(OutgoingDocumentModel doc)` — delegates to sendDocRepo
- `Future<OutgoingDocumentModel?> getOutgoingDocumentById(String id)` — delegates to sendDocRepo

#### `lib/ui/features/document/outgoing_document/services/document_detail_service.dart`
```dart
class DocumentDetailService {
  final DocumentDetailRepository repository;
  // Constructor: required, defaults to mock impl
}
```
Methods:
- `Future<DetailDocumentModel> getDocumentDetail(String id)` — fetches outgoing doc + user + workflow, maps to DetailDocumentModel

### CONTROLLERS (2 new)

#### `lib/ui/features/document/outgoing_document/controllers/send_document_controller.dart`
```dart
class SendDocumentController extends GetxController {
  final SendDocumentService service;

  // Step state
  final currentStep = 0.obs;          // 0, 1, 2

  // Step 1 — all created document titles
  final allDocumentRefs = <DocumentReferenceModel>[].obs;
  final step1Titles = <String>[].obs;  // dropdown items
  final selectedStep1Title = ''.obs;
  final selectedDocument = Rxn<DocumentModel>();

  // Step 2 — workflow template names
  final workflows = <ApprovalWorkflowModel>[].obs;
  final step2WorkflowNames = <String>[].obs;  // dropdown items
  final selectedWorkflowName = ''.obs;
  final selectedWorkflow = Rxn<ApprovalWorkflowModel>();

  // Submit
  final isSubmitting = false.obs;
}
```
Key methods:
- `onInit()` → `loadStep1Data()`
- `loadStep1Data()` → `service.fetchAllCreatedDocuments()` → populate `step1Titles` with `titleKhmer` values
- `onTitleSelected(String title)` → find `DocumentReferenceModel` by title → `selectedDocument.value` = matched doc, `isStep1Valid = true`
- `loadStep2Data()` → `service.fetchWorkflowTemplates()` → populate `step2WorkflowNames` with `workflowTitleKhmer`
- `onWorkflowSelected(String name)` → find `ApprovalWorkflowModel` by name → `selectedWorkflow.value` = matched workflow, `isStep2Valid = true`
- `nextStep()` → `currentStep++`; if moving to step 2, call `loadStep2Data()`
- `previousStep()` → `currentStep--`
- `submit()` → build `OutgoingDocumentModel`, call `service.saveOutgoingDocument()`, insert into outgoing list, close dialog

#### `lib/ui/features/document/outgoing_document/controllers/document_detail_controller.dart`
```dart
class DocumentDetailController extends GetxController {
  final DocumentDetailService service;
  final detail = Rxn<DetailDocumentModel>();
  final isLoading = true.obs;
  final error = ''.obs;
  // loadDocument(String id)
}
```

### UI — DIALOG WRAPPER (1 new)

#### `lib/ui/features/document/outgoing_document/views/widgets/send_document_dialog.dart`
- `Get.dialog(SendDocumentDialog(), barrierDismissible: false)`
- Registers `SendDocumentController` in `initState` (no tag needed since it's scoped to dialog)
- `Obx(() => switch(controller.currentStep.value) { 0 => Step1, 1 => Step2, 2 => Step3 })`
- On submit success: closes dialog → snackbar → refreshes outgoing list

### UI — STEP WIDGETS (3 new, controller-aware, visual match to existing forms)

All three match the existing `sent_document_stepX_form.dart` visual design exactly (darkBlue header "បញ្ជូនឯកសារ", arrow step indicators, same spacing/colors). They differ only in data: they read from `SendDocumentController` via `Get.find()`.

#### `lib/ui/features/document/outgoing_document/views/widgets/send_document_step1_widget.dart`
- Dropdown 1: "ចំណងជើងឯកសារ" (Document Title) — populated from `controller.step1Titles` (ALL created document titles from personal/general/incoming)
- Button "បន្ត" (Continue) → `controller.nextStep()`
- Button "លុប" (Cancel) → `Get.back()`
- Step header: Step 1 active, 2–3 inactive

#### `lib/ui/features/document/outgoing_document/views/widgets/send_document_step2_widget.dart`
- Dropdown: "លំហូរឯកសារ" (Workflow Template) — populated from `controller.step2WorkflowNames`
- Button "បន្ត" (Continue) → `controller.nextStep()`
- Button "ត្រលប់ក្រោយ" (Back) → `controller.previousStep()`
- Step header: Step 1 done, Step 2 active, Step 3 inactive

#### `lib/ui/features/document/outgoing_document/views/widgets/send_document_step3_widget.dart`
- Preview: title, document number, object, entity, date, user name, attached file (with preview/remove icons)
- "លំហូរឯកសារ" section: circles + lines showing workflow steps count
- Button "បញ្ជូន" (Submit) → `controller.submit()`
- Button "ត្រលប់ក្រោយ" (Back) → `controller.previousStep()`
- Step header: Steps 1–2 done, Step 3 active

### UI — DETAIL SCREEN (1 new)

#### `lib/ui/features/document/outgoing_document/views/detail_document_screen.dart`
```dart
class DetailDocumentScreen extends StatefulWidget {
  final String documentId;
}
```
Layout:
```
Scaffold →
  Column [
    TopNavBarWidget(title: 'ព័ត៌មានលម្អិត', onBackTap: Get.back),
    Expanded → Obx → SingleChildScrollView [
      // Basic info card (title, doc number, date, status badge, object, entity)
      // Uploader info (creator name, department, date) 
      // Files section (attachedFile name + download icon → snackbar)
      // Workflow timeline (vertical ListView of step cards:
      //   each card: step number, approver name/level, status Pending/Approved/Rejected)
    ]
  ]
```

---

## Files to Modify (2 files)

### `document_type_content.dart` — 3 changes + 1 import
1. **Button**: label ="បញ្ជូនឯកសារ" (Send) / icon=Icons.send for outgoing; "បង្កើតឯកសារថ្មី" / Icons.add for others
2. **New method**: `_openSendDocumentDialog()` → `Get.dialog(SendDocumentDialog())`
3. **Card tap**: Wrap `ListCardDocument` in `GestureDetector` with `onTap: () => Get.toNamed('/DetailDocumentScreen', arguments: doc.id.toString())` only for outgoing

### `main.dart` — 1 change
Add route:
```dart
GetPage(
  name: '/DetailDocumentScreen',
  page: () {
    final documentId = Get.arguments as String;
    return DetailDocumentScreen(documentId: documentId);
  },
),
```

---

## Dependency Injection (GetX)

| What | Where | Tag | Lifecycle |
|---|---|---|---|
| `SendDocumentController` | `SendDocumentDialog.initState()` | none | Per-dialog |
| `DocumentDetailController` | `DetailDocumentScreen.initState()` | `detail_$id` | Per-screen |
| Existing `DocumentController` | `DocumentTypeScreen.initState()` | `doc_${type}` | Per-screen (unchanged) |

---

## Complete Data Flow

```
STEP 1:
  SendDocumentController.loadStep1Data()
    → SendDocumentService.fetchAllCreatedDocuments()
      → DocumentRepository.getDocuments() [documents.json — ALL types]
    → Maps to DocumentReferenceModel
    → Populates step1Titles (dropdown items)
  User selects title
    → controller.onTitleSelected(title)
    → finds matching DocumentReferenceModel

STEP 2:
  SendDocumentController.loadStep2Data()
    → SendDocumentService.fetchWorkflowTemplates()
      → WorkflowApprovalRepository.getAllWorkflows() [approval_workflow.json]
    → Populates step2WorkflowNames (dropdown items)
  User selects workflow name
    → controller.onWorkflowSelected(name)
    → finds matching ApprovalWorkflowModel (stores steps + levels)

STEP 3:
  Shows preview from selectedDocument + selectedWorkflow
  User clicks Submit
    → controller.submit()
    → Creates OutgoingDocumentModel:
        id = DateTime.now().msSinceEpoch.toString()
        sourceDocumentId = selectedDocument.id
        titleKhmer, documentNumber, ... = from selectedDocument
        workflowTemplateId, workflowSteps = from selectedWorkflow
        status = 'កំពុងរង់ចាំ'
        createdBy = authService.currentUser.id
    → SendDocumentService.saveOutgoingDocument(model)
      → SendDocumentRepositoryImpl (in-memory cache)
    → Inserts into Get.find<DocumentController>(tag:'doc_outgoing').documents
    → Get.back() + snackbar

OUTGOING LIST:
  Shows mock docs + newly sent docs
  Each card: title + docNumber + date + status badge

DETAIL SCREEN:
  User taps card → Get.toNamed('/DetailDocumentScreen', arguments: docId)
  → DocumentDetailController.loadDocument(docId)
    → DocumentDetailService.getDocumentDetail(docId)
      → DocumentDetailRepository:
          - getOutgoingDocumentById(docId) → outgoing_documents.json
          - getWorkflows() → approval_workflow.json
          - getUserById(createdBy) → user.json
    → Maps to DetailDocumentModel
  → Renders: info card + files + workflow timeline
```

---

## Verification

1. Outgoing tab shows "បញ្ជូនឯកសារ" button; others show "បង្កើតឯកសារថ្មី"
2. Click "Send Document" → 3-step dialog opens
3. Step 1 dropdown shows ALL created document titles from personal/general/incoming
4. Selecting title → Continue → Step 2 dropdown shows workflow templates
5. Selecting workflow → Continue → Step 3 shows preview with document info + workflow steps
6. Submit → dialog closes → outgoing list refreshes with new doc showing status badge
7. Tap outgoing card → detail screen with info, files, download mock, workflow timeline
