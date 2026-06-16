import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/auth/controllers/login_controller.dart';
import 'package:e_doc_redo/ui/features/auth/screens/widgets/login_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: LoginContent(controller: controller, formKey: _formKey),
      ),
    );
  }
}
