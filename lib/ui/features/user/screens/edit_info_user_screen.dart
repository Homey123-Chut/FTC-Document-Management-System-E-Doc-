import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/screens/widgets/edit_info_user_content.dart';
import 'package:e_doc_redo/ui/widgets/navigation/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditInfoUserScreen extends GetView<ProfileController> {
  const EditInfoUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          TopNavBarWidget(
            title: 'ព័ត៌មានគណនី',
            onBackTap: () => Get.back(),
          ),
          Expanded(
            child: EditInfoUserContent(controller: controller),
          ),
        ],
      ),
    );
  }
}
