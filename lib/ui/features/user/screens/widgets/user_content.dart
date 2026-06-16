import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/screens/edit_info_user_screen.dart';
import 'package:e_doc_redo/ui/features/user/screens/widgets/menu_tile.dart';
import 'package:e_doc_redo/ui/features/user/screens/widgets/profile_header_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Pure UI body of the User screen.
/// Receives [controller] for reactive state.
/// No Scaffold — just the scrollable content.
class UserContent extends StatefulWidget {
  final ProfileController controller;

  const UserContent({super.key, required this.controller});

  @override
  State<UserContent> createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when this screen is displayed.
    // The controller is created at app start (before login), so we
    // need to trigger the fetch now that the user has logged in.
    widget.controller.fetchActiveUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // ── Profile Header (reactive) ──
        Obx(() {
          if (widget.controller.loading.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final user = widget.controller.user.value;
          if (user == null || widget.controller.hasError.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('មិនអាចទាញយកទិន្នន័យបានទេ')),
            );
          }

          return ProfileHeaderCard(
            imageUrl: user.profileImg.isNotEmpty
                ? user.profileImg
                : 'assets/images/user_avatar.png',
            roleLabel: user.role == 'admin' ? 'អគ្គលេខាធិការ' : 'បុគ្គលិក',
            userName: user.username,
            departmentLabel: 'អង្គភាព',
            departmentName: user.department,
            onCameraTap: () {},
          );
        }),

        const SizedBox(height: 12),

        // ── Account Section ──
        MenuTile(
          leadingIcon: Icons.person_outline_rounded,
          title: 'ព័ត៌មានគណនី',
          onTap: () => Get.to(() => const EditInfoUserScreen()),
        ),
        MenuTile(
          leadingIcon: Icons.notifications_none_outlined,
          title: 'ការកំណត់ការជូនដំណឹង',
          onTap: () {},
        ),

        const SizedBox(height: 16),

        // ── Management Section ──
        _buildCategoryGroupHeader('គ្រប់គ្រង'),

        MenuTile(
          leadingIcon: Icons.account_tree_outlined,
          title: 'បង្កើតលំហូរឯកសារ',
          onTap: () {},
        ),
        MenuTile(
          leadingIcon: Icons.account_balance_outlined,
          title: 'អង្គភាព',
          onTap: () {},
        ),
        MenuTile(
          leadingIcon: Icons.settings_outlined,
          title: 'កំណត់ប្រព័ន្ធ',
          onTap: () {},
        ),
        MenuTile(
          leadingIcon: Icons.people_alt_outlined,
          title: 'អ្នកប្រើប្រាស់',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCategoryGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF555962),
        ),
      ),
    );
  }
}
