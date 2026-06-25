import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

class StepArrowData {
  final String title;
  final bool isActive;

  const StepArrowData({
    required this.title,
    required this.isActive,
  });
}

class StepArrowHeader extends StatelessWidget {
  final List<StepArrowData> steps;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const StepArrowHeader({
    super.key,
    required this.steps,
    this.height = 50,
    this.activeColor = AppColors.darkBlue,
    this.inactiveColor = const Color(0xFFE8EAF6),
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = const Color(0xFF757575),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isFirst = index == 0;
          final isLast = index == steps.length - 1;
          final color = step.isActive ? activeColor : inactiveColor;
          final textColor = step.isActive ? activeTextColor : inactiveTextColor;
          final bold =
              step.isActive ? FontWeight.bold : FontWeight.normal;

          return Expanded(
            child: ClipPath(
              clipper: ArrowClipper(isFirst: isFirst, isLast: isLast),
              child: Container(
                color: color,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: isFirst ? 0 : 2,
                  right: isLast ? 0 : 2,
                ),
                child: Text(
                  step.title,
                  style: AppTextStyles.body3.copyWith(
                    color: textColor,
                    fontWeight: bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  final bool isFirst;
  final bool isLast;

  const ArrowClipper({
    required this.isFirst,
    required this.isLast,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(isFirst ? 0 : 15, 0);
    path.lineTo(size.width - 15, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 15, size.height);
    path.lineTo(isFirst ? 0 : 15, size.height);

    if (!isLast) {
      path.lineTo(15 + (isFirst ? -15 : 0), size.height / 2);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
