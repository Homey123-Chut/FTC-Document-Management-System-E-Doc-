import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset('assets/logo_fsa.png', height: 180),
        const SizedBox(height: 24),
        Text(
          'ប្រព័ន្ធគ្រប់គ្រងឯកសារ',
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: 24),
        Text(
          'សូមស្វាគមន៏',
          style: AppTextStyles.heading3,
        ),
      ],
    );
  }
}
