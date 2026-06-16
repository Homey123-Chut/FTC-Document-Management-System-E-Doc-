import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/auth/controllers/login_controller.dart';
import 'package:e_doc_redo/ui/features/auth/screens/widgets/login_form.dart';
import 'package:e_doc_redo/ui/features/auth/screens/widgets/login_header.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_method_login_tile.dart';
import 'package:flutter/material.dart';


class LoginContent extends StatelessWidget {
  final LoginController controller;
  final GlobalKey<FormState> formKey;

  const LoginContent({
    super.key,
    required this.controller,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoginHeader(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  LoginForm(formKey: formKey, controller: controller),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'ចូលប្រើប្រាស់ដោយ',
                          style: TextStyle(color: AppColors.darkBlue),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  MethodLoginTileWidget(
                    icon: 'assets/camDigiKey.png',
                    text: 'ចូលប្រព័ន្ធដោយប្រើប្រាស់ CamDigiKey',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
