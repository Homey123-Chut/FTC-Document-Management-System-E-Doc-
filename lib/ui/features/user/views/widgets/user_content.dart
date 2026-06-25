import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/views/workflow_approval_screen.dart';
import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/views/edit_info_user_screen.dart';
import 'package:e_doc_redo/ui/features/user/views/widgets/menu_tile.dart';
import 'package:e_doc_redo/ui/features/user/views/widgets/profile_header_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserContent extends GetView<ProfileController> {
  const UserContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
      children: [
        Obx(() {
          if (controller.loading.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32,),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final user = controller.user.value;
          if (user == null || controller.hasError.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('មិនអាចទាញយកទិន្នន័យបានទេ')),
            );
          }

          return Obx(() {
            final isUploading = controller.isUploadingImage.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileHeaderCard(
                imageUrl: controller.profileImageUrl,
                roleLabel: controller.roleLabel,
                userName: user.username,
                entityLabel: 'អង្គភាព',
                entityName: user.department,
                onCameraTap:
                    isUploading ? null : () => controller.pickAndUploadImage(),
              ),
            );
          });
        }),

        const SizedBox(height: 18),

        MenuTile(
          leadingIcon: Icons.person_outline_rounded,
          title: 'ព័ត៌មានគណនី',
          onTap: () => Get.to(() => const EditInfoUserScreen()),
        ),

        const SizedBox(height: 6),

        MenuTile(
          leadingIcon: Icons.notifications_none_outlined,
          title: 'ការកំណត់ការជូនដំណឹង',
          onTap: () {},
        ),

        const SizedBox(height: 16),

         Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: 8,
          ),
          child: Text(
            'គ្រប់គ្រង',
            style: AppTextStyles.label4,
          ),
        ),

        MenuTile(
          leadingIcon: Icons.account_tree_outlined,
          title: 'បង្កើតលំហូរឯកសារ',
          onTap: () => Get.to(() => const WorkflowApprovalScreen()),    
        ),

        const SizedBox(height: 6),

        MenuTile(
          leadingIcon: Icons.account_balance_outlined,
          title: 'អង្គភាព',
          onTap: () {},
        ),

        const SizedBox(height: 6),

        MenuTile(
          leadingIcon: Icons.settings_outlined,
          title: 'កំណត់ប្រព័ន្ធ',
          onTap: () {},
        ),

        const SizedBox(height: 6),

        MenuTile(
          leadingIcon: Icons.people_alt_outlined,
          title: 'អ្នកប្រើប្រាស់',
          onTap: () {},
        ),

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: OutlinedButton.icon(
            onPressed: () => controller.logout(),
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.darkRed,
            ),
            label: const Text(
              'ចាកចេញ',
              style: TextStyle(
                color: AppColors.darkRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              side: WidgetStateProperty.resolveWith<BorderSide>(
                (states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const BorderSide(
                      color: AppColors.darkRed,
                    );
                  }

                  return const BorderSide(
                    color: AppColors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
