import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/core/utils/file_extension.dart';
import 'package:e_doc_redo/data/models/file/attached_file_info.dart';
import 'package:flutter/material.dart';

/// A single file row shown below the upload button.
/// Displays the file icon, name, size, and an optional remove button.
///
/// Used by [UploadField] to render the list of selected files.
class UploadFileTile extends StatelessWidget {
  final AttachedFileInfo file;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const UploadFileTile({
    super.key,
    required this.file,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(
                FileExtension.iconFor(file.extension),
                size: 18,
                color: FileExtension.colorFor(file.extension),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: AppTextStyles.body3.copyWith(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (file.size > 0)
                      Text(
                        file.formattedSize,
                        style: AppTextStyles.caption2.copyWith(fontSize: 10),
                      ),
                  ],
                ),
              ),
              if (onRemove != null)
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
