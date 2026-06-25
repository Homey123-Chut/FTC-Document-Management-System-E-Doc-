import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/file/attached_file_info.dart';
import 'package:e_doc_redo/ui/widgets/inputs/upload_file_tile.dart';
import 'package:flutter/material.dart';

// Re-export for backward compatibility — existing consumers import these
// symbols from this file.
export 'package:e_doc_redo/data/models/file/attached_file_info.dart';
export 'package:e_doc_redo/ui/widgets/inputs/upload_file_preview_sheet.dart'
    show showFilePreview;

/// A reusable field that lets users upload multiple files.
///
/// The upload button stays visually identical regardless of state.
/// Selected files appear as tappable / removable [UploadFileTile] rows
/// below it — same colour palette and border radius as the original design.
///
/// Business logic (file picking, validation, upload) lives in
/// [UploadController]; this widget is pure UI.
class UploadField extends StatelessWidget {
  final String label;
  final String hintText;
  final List<AttachedFileInfo> files;
  final VoidCallback onTap;
  final void Function(int index)? onRemove;
  final void Function(int index)? onTapFile;

  const UploadField({
    super.key,
    required this.label,
    this.hintText = 'ជ្រើសរើសឯកសារ',
    this.files = const [],
    required this.onTap,
    this.onRemove,
    this.onTapFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subtitle3),
        const SizedBox(height: 8),

        // ── Upload button ───────────────────────────────────────────────
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBlue, width: 1.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.file_upload_outlined,
                    color: AppColors.darkBlue, size: 28),
                const SizedBox(height: 8),
                Text(
                  files.isEmpty ? hintText : 'បានជ្រើសរើស ${files.length} ឯកសារ',
                  style: AppTextStyles.label2,
                ),
              ],
            ),
          ),
        ),

        // ── Uploaded file list ──────────────────────────────────────────
        if (files.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...files.asMap().entries.map(
                (entry) => UploadFileTile(
                  file: entry.value,
                  onTap:
                      onTapFile != null ? () => onTapFile!(entry.key) : null,
                  onRemove:
                      onRemove != null ? () => onRemove!(entry.key) : null,
                ),
              ),
        ],
      ],
    );
  }
}
