
import 'package:e_doc_redo/ui/features/approval_workflow/controllers/workflow_approval_controller.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/views/widgets/approval_workflow_card.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalWorkflowContent extends GetView<WorkflowApprovalController> {
  const ApprovalWorkflowContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title and Create Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Title and Subtitle Row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "លំហូរឯកសារ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937)),
                  ),
                  const SizedBox(height: 4),
                  // The one-row subtitle section
                  Column(
                    children: [
                      Text(
                        "គ្រប់គ្រងលំហូរការងារ",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "និងការអនុម័ត",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),

              // Right: Filter Button and Create Button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF4B5563)),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  ButtonWidget(
                    text: "បង្កើតលំហូរឯកសារ",
                    icon: Icons.add,
                    onPressed: controller.showCreateDialog,
                  ),
                ],
              ),
            ],
          ),

          // List of Workflow Cards
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.workflows.isEmpty) {
                return Center(
                  child: Text(
                    'មិនទាន់មានលំហូរឯកសារ',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              return ListView.separated(
                itemCount: controller.workflows.length,
                padding: const EdgeInsets.only(top: 14, bottom: 20),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final workflow = controller.workflows[index];
                  return ApprovalWorkflowCard(
                    workflow: workflow,
                    onEdit: () {
                      // Navigate to Edit
                    },
                    onDelete: () {
                      controller.confirmDeleteWorkflow(workflow.id);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}