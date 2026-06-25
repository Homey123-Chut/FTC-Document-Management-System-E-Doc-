import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/views/widgets/user_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserScreen extends GetView<ProfileController> {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: const UserContent(),
          ),
        ],
      ),
    );
  }
}
