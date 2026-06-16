import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/approval/controllers/level_workflow_controller.dart';
import 'package:e_doc_redo/ui/features/approval/controllers/workflow_approval_controller.dart';
import 'package:e_doc_redo/ui/features/approval/repository_impl/workflow_approval_repository_impl.dart';
import 'package:e_doc_redo/ui/features/approval/repository_impl/level_workflow_repository_impl.dart';
import 'package:e_doc_redo/ui/features/approval/services/level_workflow_service.dart';
import 'package:e_doc_redo/ui/features/approval/services/workflow_approval_service.dart';
import 'package:e_doc_redo/ui/features/approval/views/widgets/approval_workflow_content.dart';
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
  @override
  void initState() {
    super.initState();
    Get.put(WorkflowApprovalController(
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
            onBackTap: () => Get.back(),
            onSearchTap: () {},
          ),
          const Expanded(
            child: ApprovalWorkflowContent(),
          ),
        ],
      ),
    );
  }
}
