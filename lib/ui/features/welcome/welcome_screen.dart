import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/welcome/widgets/welcome_content.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: const WelcomeContent(),
    );
  }
}
