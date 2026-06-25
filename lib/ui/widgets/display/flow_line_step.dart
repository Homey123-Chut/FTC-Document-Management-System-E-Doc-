import 'package:flutter/material.dart';

class FlowLineStep<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T item) labelBuilder;

  /// Static fallback colors (used when no per-step builder is provided).
  final Color circleColor;
  final Color lineColor;
  final double circleSize;
  final double lineThickness;

  /// Per-step circle fill colour. Overrides [circleColor] for step [i].
  final Color? Function(int i)? circleColorBuilder;

  /// Per-step circle border. Use for outlining future steps (e.g. white fill
  /// with coloured border).
  final Border? Function(int i)? circleBorderBuilder;

  /// Per-step connector line colour. Overrides [lineColor] for the line
  /// between step [i] and step [i + 1].
  final Color? Function(int i)? lineColorBuilder;

  final TextStyle? numberStyle;
  final TextStyle? labelStyle;
  final Widget Function(int index)? iconBuilder;

  const FlowLineStep({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.circleColor = const Color(0xFF4F46E5),
    this.lineColor = const Color(0xFF4F46E5),
    this.circleSize = 42,
    this.lineThickness = 3,
    this.circleColorBuilder,
    this.circleBorderBuilder,
    this.lineColorBuilder,
    this.numberStyle,
    this.labelStyle,
    this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 12.0;
        final maxContentWidth =
            (constraints.maxWidth - (horizontalPadding * 2))
                .clamp(0.0, double.infinity);
        final stepCount = items.length;
        final lineCount = stepCount - 1;

        final availableLineWidth = lineCount > 0
            ? (maxContentWidth - (circleSize * stepCount)) / lineCount
            : 0.0;

        /// Dynamic line width based on available space and step count.
        final dynamicLineWidth = lineCount > 0
            ? availableLineWidth.clamp(20.0, double.infinity)
            : 0.0;

        final totalWidth =
            (circleSize * stepCount) + (dynamicLineWidth * lineCount);

        final stepRow = _buildStepRow(dynamicLineWidth, lineCount);

        // Fit → centre. Overflow → horizontal scroll.
        if (totalWidth <= maxContentWidth) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: horizontalPadding),
            child: Center(child: stepRow),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 16, horizontal: horizontalPadding),
              child: stepRow,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepRow(double lineWidth, int lineCount) {
    final stepCount = items.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Top row — circles + connector lines ──────────────────────
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < stepCount; i++) ...[
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: circleColorBuilder?.call(i) ?? circleColor,
                  shape: BoxShape.circle,
                  border: circleBorderBuilder?.call(i),
                ),
                alignment: Alignment.center,
                child: iconBuilder?.call(i) ??
                    Text(
                      '${i + 1}',
                      style: numberStyle ??
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
              ),
              if (i < lineCount)
                Container(
                  width: lineWidth,
                  height: lineThickness,
                  color: lineColorBuilder?.call(i) ?? lineColor,
                ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        // ── Bottom row — labels ──────────────────────────────────────
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < stepCount; i++) ...[
              SizedBox(
                width: circleSize,
                child: Center(
                  child: Text(
                    labelBuilder(items[i]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle ??
                        const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              if (i < lineCount) SizedBox(width: lineWidth),
            ],
          ],
        ),
      ],
    );
  }
}
