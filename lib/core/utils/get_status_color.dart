import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

extension StatusLevelColorX on String {
  Color get statusLevelColor {
    switch (toLowerCase()) {
      case 'high':
        return AppColors.darkRed;
      case 'medium':
        return AppColors.yellow;
      case 'low':
        return AppColors.darkGreen;
      default:
        return AppColors.grey;
    }
  }
}
