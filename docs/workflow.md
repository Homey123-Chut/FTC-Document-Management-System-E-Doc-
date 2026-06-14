Ready for review
Select text to add comments on the plan
Plan: Fix & Complete Approval Workflow Feature
Context
The Approval Workflow feature module exists as files under lib/ui/features/approval/ and lib/data/ but has critical bugs that prevent compilation and runtime:

Repository implementations load from wrong file paths / JSON keys
Form widgets have undefined controller references, broken Dart syntax, and type mismatches
The card widget uses a non-existent Workflow type instead of ApprovalWorkflowModel
No controller is registered in GetX DI — navigating to WorkflowApprovalScreen would crash
No navigation entry point is wired — the feature is unreachable
Goal: Fix all bugs so the two-step workflow creation flow works end-to-end with mock JSON data, and the approval workflow screen displays cards loaded from JSON, all following the existing MVC+GetX architecture.

Implementation Plan
Step 1: Fix Repository Implementations (2 files)
lib/ui/features/approval/repositories_impl/workflow_approval_repository_impl.dart

Line 13: Change 'lib/data/mock_data/approval_workflows.json' → 'lib/data/mock_data/approval_workflow.json' (remove extra 's')
lib/ui/features/approval/repositories_impl/workflow_level_repository_impl.dart

Line 14: Change 'lib/data/mock_data/levels.json' → 'lib/data/mock_data/level_workflow.json'
Line 19: Change jsonData['levels'] → jsonData['levels_workflow']
Step 2: Add selectedDocumentType to Controller
lib/ui/features/approval/controllers/workflow_approval_controller.dart

Add after isLoading: final RxString selectedDocumentType = ''.obs;
This carries the doc type choice from Step 1 to Step 2
Step 3: Rewrite approval_workflow_card.dart
lib/ui/features/approval/views/widgets/approval_workflow_card.dart

Replace entirely. New card shows:

Khmer title (workflowTitleKhmer) as headline
Latin title (workflowTitleLatin) as subtitle in grey
Description
Metadata row: ID, total documents, total levels, created date
Divider
Steps shown as level1 > level2 > level3 breadcrumb
Edit + Delete icon buttons
Uses ApprovalWorkflowModel (import from lib/data/models/approval_workflow/approval_workflow.dart). Keep the white container with 24px border radius and grey border matching existing UI style. Use AppTextStyles and AppColors from theme.

Step 4: Fix approval_workflow_content.dart
lib/ui/features/approval/views/widgets/approval_workflow_content.dart

Line 83, 86: controller.workflowList → controller.workflows
Line 70-72: Wire create button onPressed to navigate to Step 1 form:
onPressed: () => Get.to(() => const WorkflowStep1Form()),
Add import for workflow_step1_form.dart
Step 5: Rewrite workflow_step1_form.dart
lib/ui/features/approval/views/widgets/forms/workflow_step1_form.dart

Full rewrite. Convert from StatelessWidget to StatefulWidget.

State variables:

String _selectedDocType = 'ឯកសារចូល'
final List<String> _docTypes = ['ឯកសារចូល', 'ឯកសារចេញ']
Controller references via Get.find<WorkflowApprovalController>() and Get.find<LevelController>()
UI structure (preserving existing design):

Step header (Step 1 active/darkBlue, Step 2 inactive/grey) — same as current _buildStepHeader()
Level dropdown — wrapped in Obx, items from _levelController.levels.map((l) => l.name).toList(), value from _levelController.selectedLevel, uses DropdownField widget
Document type dropdown — uses local _selectedDocType state, options ['ឯកសារចូល', 'ឯកសារចេញ'], uses DropdownField
Dynamic approval steps — wrapped in Obx over _workflowController.approvalSteps. Each step renders a DropdownField with label "ទី {index+1}", items from _levelController.levels, onChanged updates the step in the RxList via assignAll pattern
Add button — ButtonWidget(text: "បន្ថែម", icon: Icons.add) → creates new ApprovalStepModel and calls _workflowController.addApprovalStep()
Footer buttons — Cancel (Get.back()) + Continue (saves state, navigates to ApprovalWorkflowStep2Form)
Key pattern for updating step dropdowns (triggering Obx rebuild):

onChanged: (val) {
  final steps = List<ApprovalStepModel>.from(controller.approvalSteps);
  steps[i] = ApprovalStepModel(stepNumber: i+1, level: val!, flowLevel: 'Step ${i+1}');
  controller.approvalSteps.assignAll(steps);
}
Step 6: Rewrite workflow_step2_form.dart
lib/ui/features/approval/views/widgets/forms/workflow_step2_form.dart

Full rewrite. Convert from StatelessWidget to StatefulWidget.

State variables:

final _khmerTitleController = TextEditingController()
final _latinTitleController = TextEditingController()
final _formKey = GlobalKey<FormState>()
UI structure (preserving existing design):

Step header (Step 1 inactive/grey, Step 2 active/darkBlue with chevron style)
TextFieldWidget for Khmer title (label: "ចំណងជើង", required)
TextFieldWidget for Latin title (label: "ចំណងជើងឡាតាំង", required)
Footer: Cancel (Get.back()) + Create button
Create logic:

Validate form
Get WorkflowApprovalController via Get.find()
Build ApprovalWorkflowModel with DateTime.now().millisecondsSinceEpoch.toString() as ID, steps from controller.approvalSteps, totalLevels = steps.length, totalDocuments = 0, createdAt = DateTime.now()
Call controller.createWorkflow(workflow)
Get.back() twice to return to the workflow list screen
Show success snackbar
Add import: import 'package:e_doc_redo/core/theme/theme.dart';

Step 7: Fix workflow_approval_screen.dart
lib/ui/features/approval/views/workflow_approval_screen.dart

Convert from GetView<WorkflowApprovalController> to StatefulWidget (following the FoldersScreen pattern).

initState(): Register both controllers:

Get.put(WorkflowApprovalController(
  service: WorkflowApprovalService(WorkflowApprovalRepositoryImpl()),
));
Get.put(LevelController(
  service: LevelWorkflowService(WorkflowLevelRepositoryImpl()),
));
dispose(): Delete both controllers:

Get.delete<WorkflowApprovalController>();
Get.delete<LevelController>();
build(): Keep existing Scaffold with TopNavBarWidget and ApprovalWorkflowContent. Add the missing import for ApprovalWorkflowContent and all required controller/service/repo imports.

Step 8: Wire Navigation Entry Points (2 files)
lib/ui/features/user/views/widgets/user_content.dart (line 86)

Change onTap: () {} to onTap: () => Get.to(() => const WorkflowApprovalScreen())
Add import for workflow_approval_screen.dart
lib/main.dart — MainScreen FAB (line 105)

Change onPressed: () {} to:
onPressed: () => Get.to(() => const WorkflowApprovalScreen()),
Add import for workflow_approval_screen.dart
Step 9: Clean up level_workflow.json duplicate
lib/data/mock_data/level_workflow.json — Remove duplicate "មជ្ឈមណ្ឌលបច្ចេកវិទ្យាហិរញ្ញ" entry (appears at index 0 and index 3).

Files Modified (Summary)
#	File	Action
1	repositories_impl/workflow_approval_repository_impl.dart	Fix JSON file path
2	repositories_impl/workflow_level_repository_impl.dart	Fix JSON file path + key
3	controllers/workflow_approval_controller.dart	Add selectedDocumentType field
4	views/widgets/approval_workflow_card.dart	Rewrite to use ApprovalWorkflowModel
5	views/widgets/approval_workflow_content.dart	Fix property name + wire create button
6	views/widgets/forms/workflow_step1_form.dart	Full rewrite (StatefulWidget, proper Obx+DropdownField)
7	views/widgets/forms/workflow_step2_form.dart	Full rewrite (StatefulWidget, create logic)
8	views/workflow_approval_screen.dart	Add DI registration, fix imports
9	user/views/widgets/user_content.dart	Wire menu onTap
10	main.dart	Wire FAB onPressed
11	mock_data/level_workflow.json	Remove duplicate entry
Navigation Flow (Final)
MainScreen FAB (+) or User menu "បង្កើតលំហូរឯកសារ"
  → Get.to(WorkflowApprovalScreen)
    → registers WorkflowApprovalController + LevelController
    → shows ApprovalWorkflowContent with list of workflow cards
    → "បង្កើតលំហូរឯកសារ" button
      → Get.to(WorkflowStep1Form) [uses registered controllers]
        → fill level, doc type, approval steps
        → "បន្ត"
          → Get.to(ApprovalWorkflowStep2Form)
            → fill khmer title, latin title
            → "បង្កើត"
              → controller.createWorkflow(model)
              → Get.back() x2 → back to list
              → new card appears at top
Data Flow
level_workflow.json → LevelWorkflowRepositoryImpl → LevelWorkflowService → LevelController
                                                                              ↓
                                                              WorkflowStep1Form (dropdown items)
                                                                              ↓
approval_workflow.json → WorkflowApprovalRepositoryImpl → WorkflowApprovalService → WorkflowApprovalController
                                                                                          ↓
                                                              ApprovalWorkflowContent → ApprovalWorkflowCard
Architecture Rules Preserved
MVC + GetX: Controller handles state, Service handles business logic, Repository handles data
Screens only inject content widgets and manage controller lifecycle
All UI inside content widgets
Obx for reactive updates
DropdownField / ButtonWidget / TextFieldWidget shared widgets reused
Get.put() in initState(), Get.delete() in dispose() for screen-scoped controllers
Optimistic UI pattern: insert into RxList first, persist via service
Verification
Hot restart the app — no compilation errors
Navigate to Approval Workflow screen via FAB (+) or User menu → see 12 workflow cards loaded from JSON
Click "បង្កើតលំហូរឯកសារ" → Step 1 form appears with level dropdown populated from level_workflow.json
Select level, document type, configure steps → Add button creates ទី៣, ទី៤, etc.
Click "បន្ត" → Step 2 form appears with title fields
Enter titles and click "បង្កើត" → returns to workflow list with new card at top
Verify card contents: Khmer title, Latin title, ID, total documents, total steps, steps breadcrumb
Delete a workflow → card removed from list
Navigate back via TopNavBar → returns to previous screen
Add Comment