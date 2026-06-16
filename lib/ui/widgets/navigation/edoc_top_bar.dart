import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo_fsa.png',
            height: 70,
            width: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edoc',
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 1),
                Text(
                  'Document System',
                  style: AppTextStyles.body3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
