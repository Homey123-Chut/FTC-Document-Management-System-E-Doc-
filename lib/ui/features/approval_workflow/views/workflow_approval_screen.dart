import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/approval_workflow_search_controller.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/level_workflow_controller.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/workflow_approval_controller.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/repositories_impl/workflow_approval_repository_impl.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/repositories_impl/level_workflow_repository_impl.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/services/level_workflow_service.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/services/workflow_approval_service.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/views/approval_workflow_search_screen.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/views/widgets/approval_workflow_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkflowApprovalScreen extends StatefulWidget {
  const WorkflowApprovalScreen({super.key});

  @override
  State<WorkflowApprovalScreen> createState() =>
      _WorkflowApprovalScreenState();
}

class _WorkflowApprovalScreenState extends State<WorkflowApprovalScreen> {
  late final WorkflowApprovalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(WorkflowApprovalController(
      service: WorkflowApprovalService(WorkflowApprovalRepositoryImpl()),
    ));
    Get.put(LevelController(
      service: LevelWorkflowService(WorkflowLevelRepositoryImpl()),
    ));
  }

  @override
  void dispose() {
    Get.delete<WorkflowApprovalController>();
    Get.delete<LevelController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          TopNavBarWidget(
            title: 'Approval Workflow',
            onBackTap: _controller.goBack,
            onSearchTap: () => Get.to(
              () => const ApprovalWorkflowSearchScreen(),
              binding: BindingsBuilder(() {
                Get.put(ApprovalWorkflowSearchController());
              }),
            ),
          ),
          const Expanded(
            child: ApprovalWorkflowContent(),
          ),
        ],
      ),
    );
  }
}
