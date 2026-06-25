import 'dart:typed_data';

import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/data/models/file/attached_file_info.dart';
import 'package:flutter/material.dart';

/// Shows a modal bottom-sheet that previews the given [file].
/// Images are displayed inline with pinch-to-zoom; other file types
/// show a metadata card.
void showFilePreview(BuildContext context, AttachedFileInfo file) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => UploadFilePreviewSheet(file: file),
  );
}

/// Bottom-sheet content for previewing an attached file.
class UploadFilePreviewSheet extends StatelessWidget {
  final AttachedFileInfo file;

  const UploadFilePreviewSheet({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'ការមើលឯកសារ',
                style: AppTextStyles.subtitle1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Content — image or metadata
              Expanded(
                child: FilePreviewContent(file: file),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Chooses between an image preview and a metadata card based on file type.
class FilePreviewContent extends StatelessWidget {
  final AttachedFileInfo file;

  const FilePreviewContent({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    if (file.isImage && file.bytes != null && file.bytes!.isNotEmpty) {
      return FilePreviewImage(bytes: file.bytes!);
    }
    return FilePreviewMetadata(file: file);
  }
}

/// Pinch-to-zoom image viewer for attached image files.
class FilePreviewImage extends StatelessWidget {
  final Uint8List bytes;

  const FilePreviewImage({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: InteractiveViewer(
        child: Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Metadata card showing file name, size, type, and optional path.
class FilePreviewMetadata extends StatelessWidget {
  final AttachedFileInfo file;

  const FilePreviewMetadata({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F7FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              file.isImage ? Icons.image : Icons.insert_drive_file,
              size: 64,
              color: AppColors.darkBlue.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              file.name,
              style: AppTextStyles.subtitle2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FileInfoRow(label: 'ទំហំ', value: file.formattedSize),
            const SizedBox(height: 6),
            FileInfoRow(
              label: 'ប្រភេទ',
              value: file.extension.isNotEmpty
                  ? file.extension.toUpperCase()
                  : 'មិនស្គាល់',
            ),
            if (file.path != null && file.path!.isNotEmpty) ...[
              const SizedBox(height: 6),
              FileInfoRow(label: 'ទីតាំង', value: file.path!),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single label : value row used inside the file metadata card.
class FileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const FileInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.caption2.copyWith(color: Colors.grey),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.body4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
