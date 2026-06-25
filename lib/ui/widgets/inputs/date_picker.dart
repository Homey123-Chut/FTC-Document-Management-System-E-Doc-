import 'package:e_doc_redo/ui/widgets/inputs/edoc_input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';

class DatePicker extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;

  const DatePicker({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = true,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.darkBlue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFieldWidget(
          label: label,
          controller: controller,
          hintText: 'ថ្ងៃ/ខែ/ឆ្នាំ',
          isRequired: isRequired,
          suffixIcon: const Icon(Icons.calendar_today, color: AppColors.grey, size: 20),
        ),
      ),
    );
  }
}
