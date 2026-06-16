import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/auth/screens/login_screen.dart';
import 'package:e_doc_redo/ui/features/welcome/widgets/welcome_header.dart';
import 'package:e_doc_redo/ui/widgets/cards/edoc_method_login_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Forward reference — WelcomeScreen is defined in the Screen file that wraps this Content.
// The circular import is avoided by using Get.toNamed or a direct reference to LoginScreen.

/// Pure UI body of the Welcome screen.
class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WelcomeHeader(),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'សូមជ្រើសរើសវិធីមួយដើម្បីចូលទៅកាន់ប្រព័ន្ធ',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title3,
                    ),
                    const SizedBox(height: 30),
                    MethodLoginTileWidget(
                      icon: 'assets/camDigiKey.png',
                      text: 'ចូលប្រព័ន្ធដោយប្រើប្រាស់ CamDigiKey',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    MethodLoginTileWidget(
                      icon: 'assets/Login.jpg',
                      text: 'ចូលប្រព័ន្ធដោយប្រើប្រាស់ពាក្យសម្ងាត់',
                      onTap: () => Get.to(() => const LoginScreen()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
