
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class TextFieldWidget extends StatelessWidget {

  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool isRequired;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
    this.isRequired = true,
    this.textStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: labelStyle ?? AppTextStyles.subtitle3,
            children: [
              if (isRequired)
                TextSpan(
                  text: ' * ',
                  style: AppTextStyles.statusRejected,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: textStyle ?? AppTextStyles.body1,
          
          validator: validator ?? (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return 'សូមបញ្ចូលព័ត៌មាន $label ';
            }
            return null;
          },
          
          decoration: InputDecoration(
            hintText: hintText ?? label,
            hintStyle: AppTextStyles.body2,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            errorStyle: AppTextStyles.statusRejected,
            
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.darkBlue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.darkRed, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.darkRed, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}