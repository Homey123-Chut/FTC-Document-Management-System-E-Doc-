import '../../../core/theme/theme.dart';
import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? dropdownLabel;
  final String? headerLabel;
  final TextStyle? labelStyle;
  final TextStyle? itemTextStyle;
  final TextStyle? selectedTextStyle;
  final bool? isRequired;

  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.dropdownLabel,
    this.headerLabel,
    this.labelStyle,
    this.itemTextStyle,
    this.selectedTextStyle,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> menuItems = [
      if (headerLabel != null)
        DropdownMenuItem<String>(
          value: "",
          enabled: false,
          child: Text(
            headerLabel!,
            style: AppTextStyles.subtitle3,
          ),
        ),
      if (dropdownLabel != null)
        DropdownMenuItem<String>(
          value: dropdownLabel,
          enabled: false,
          child: Text(
            dropdownLabel!,
            style: AppTextStyles.subtitle3,
          ),
        ),
      ...items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              item,
              style: itemTextStyle ?? AppTextStyles.label1,
            ),
          ),
        );
      }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: labelStyle ?? AppTextStyles.caption1,
            children: [
              if (isRequired == true)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: items.contains(value) ? value : null,
          icon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.grey,
            ),
          ),
          style: selectedTextStyle ?? AppTextStyles.subtitle4,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.darkBlue,
                width: 1.5,
              ),
            ),
          ),
          items: menuItems,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          selectedItemBuilder: (BuildContext context) {
            return menuItems.map<Widget>((menuItem) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  menuItem.value == "" ? "" : (menuItem.value ?? ''),
                  style: selectedTextStyle ?? AppTextStyles.subtitle4,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}