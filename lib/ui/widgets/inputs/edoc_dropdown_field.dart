


import '../../../core/theme/theme.dart';
import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final String? value; // Changed to String? to support null/unselected
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? dropdownLabel;

  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.dropdownLabel,
  });

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> menuItems = [
      // ADDED HEADER ITEM
      const DropdownMenuItem<String>(
        value: "header_dummy",
        enabled: false,
        child: Text(
          "គោលដៅ",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBlue),
        ),
      ),
      if (dropdownLabel != null)
        DropdownMenuItem<String>(
          value: dropdownLabel,
          enabled: false,
          child: Text(dropdownLabel!, style: AppTextStyles.label2),
        ),
      ...items.map((String item) {
        final bool isSelected = item == value;
        return DropdownMenuItem<String>(
          value: item,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isSelected ? AppColors.darkBlue : AppColors.grey),
                  color: isSelected ? AppColors.darkBlue : Colors.transparent,
                ),
                child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(item, style: AppTextStyles.label2)),
            ],
          ),
        );
      })
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label2),
        const SizedBox(height: 18),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: (items.contains(value)) ? value : null, // USE 'value' NOT 'initialValue'
          icon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.grey)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.darkBlue, width: 1.5)),
          ),
          items: menuItems,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          selectedItemBuilder: (BuildContext context) {
            return menuItems.map<Widget>((DropdownMenuItem<String> menuItem) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  menuItem.value == "header_dummy" ? "" : (menuItem.value ?? ''),
                  style: AppTextStyles.label2,
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