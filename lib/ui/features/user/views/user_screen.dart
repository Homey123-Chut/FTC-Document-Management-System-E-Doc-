import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/views/widgets/user_content.dart';
import 'package:e_doc_redo/ui/widgets/display/edoc_top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserScreen extends GetView<ProfileController> {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          TopNavBarWidget(
            title: 'គណនី',
          ),
          Expanded(
            child: UserContent(controller: controller),
          ),
        ],
      ),
    );
  }
}
