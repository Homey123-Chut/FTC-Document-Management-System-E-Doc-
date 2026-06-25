import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

class EdocSearch extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const EdocSearch({
    super.key,
    required this.controller,
    this.hintText,
    this.autofocus = false,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        style: AppTextStyles.body1,
        decoration: InputDecoration(
          hintText: hintText ?? 'ស្វែងរក',
          hintStyle: AppTextStyles.body2,
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          suffixIcon: _ClearButton(controller: controller, onClear: onClear),
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.darkBlue, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;

  const _ClearButton({required this.controller, this.onClear});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        if (value.text.isEmpty) return const SizedBox.shrink();
        return IconButton(
          icon: const Icon(Icons.clear, color: AppColors.grey, size: 20),
          onPressed: () {
            controller.clear();
            onClear?.call();
          },
        );
      },
    );
  }
}
