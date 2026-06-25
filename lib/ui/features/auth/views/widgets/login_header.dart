import 'package:flutter/material.dart';
import '../../../../../../core/theme/theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/logo_fsa.png',
           height: 120
        ),
        const SizedBox(height: 16),
        Text(
          'ប្រព័ន្ធគ្រប់គ្រងឯកសារ',
          style: AppTextStyles.heading1,
        ),
      ],
    );
  }
}
