import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/widgets/buttons/edoc_button.dart';
import 'package:flutter/material.dart';

class HeaderFolderSection extends StatelessWidget {
  final VoidCallback onCreateFolder;

  const HeaderFolderSection({
    super.key,
    required this.onCreateFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'រាយបញ្ជីរថតដាក់ឯកសារ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tune, color: Colors.grey),
          style: IconButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: ButtonWidget(
            text: 'បង្កើតសំណុំឯកសារ',
            icon: Icons.add,
            height: 42,
            backgroundColor: AppColors.darkBlue,
            onPressed: onCreateFolder,
          ),
        ),
      ],
    );
  }
}
