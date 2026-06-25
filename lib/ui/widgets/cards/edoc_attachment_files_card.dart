import 'package:e_doc_redo/services/download_service.dart';
import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _FileIcon {
  final IconData icon;
  final Color color;
  final String label;
  const _FileIcon(this.icon, this.color, this.label);
}

class AttachmentCard extends StatelessWidget {
  final List<String> attachedFiles;
  final double borderRadius;
  final Border? border;
  final Color downloadIconColor;

  final Map<String, DownloadStatus> downloadStatuses;
  final Map<String, double> downloadProgress;
  final void Function(String fileName)? onDownload;

  const AttachmentCard({
    super.key,
    required this.attachedFiles,
    this.borderRadius = 20,
    this.border,
    this.downloadIconColor = AppColors.darkBlue,
    this.downloadStatuses = const {},
    this.downloadProgress = const {},
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ឯកសារ និងឯកសារភ្ជាប់',
              style: AppTextStyles.subtitle2),
          const SizedBox(height: 18),
          if (attachedFiles.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('មិនមានឯកសារភ្ជាប់',
                    style: AppTextStyles.body2),
              ),
            )
          else
            ...attachedFiles.asMap().entries.map((e) => Padding(
                  padding: EdgeInsets.only(
                      bottom: e.key == attachedFiles.length - 1 ? 0 : 12),
                  child: _FileTile(
                    fileName: e.value,
                    downloadIconColor: downloadIconColor,
                    status: downloadStatuses[e.value] ?? DownloadStatus.idle,
                    progress: downloadProgress[e.value] ?? 0.0,
                    onDownload: onDownload,
                  ),
                )),
        ],
      ),
    );
  }

  static _FileIcon _fileIconMeta(String fileName) {
    final cleanFileName = fileName.trim();
    final ext = cleanFileName.contains('.')
        ? cleanFileName.split('.').last.toLowerCase()
        : '';
    switch (ext) {
      case 'pdf':
        return _FileIcon(Icons.picture_as_pdf, Colors.red, 'PDF');
      case 'docx':
      case 'doc':
        return _FileIcon(Icons.description, Colors.blue, 'Word');
      case 'xlsx':
      case 'xls':
        return _FileIcon(Icons.table_chart, Colors.green, 'Excel');
      case 'pptx':
      case 'ppt':
        return _FileIcon(Icons.slideshow, Colors.orange, 'PowerPoint');
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return _FileIcon(Icons.image, Colors.purple, 'Image');
      default:
        return _FileIcon(Icons.insert_drive_file, Colors.grey, 'Unknown');
    }
  }
}


class _FileTile extends StatelessWidget {
  final String fileName;
  final Color downloadIconColor;
  final DownloadStatus status;
  final double progress;
  final void Function(String fileName)? onDownload;

  const _FileTile({
    required this.fileName,
    required this.downloadIconColor,
    required this.status,
    required this.progress,
    this.onDownload,
  });

  bool get _isDownloading => status == DownloadStatus.downloading;
  bool get _isCompleted => status == DownloadStatus.completed;

  @override
  Widget build(BuildContext context) {
    final meta = AttachmentCard._fileIconMeta(fileName);
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(meta.icon, color: meta.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName, style: AppTextStyles.body3),
                Text(
                  _isCompleted ? 'បានទាញយក' : meta.label,
                  style: AppTextStyles.caption2.copyWith(
                    color: _isCompleted ? AppColors.green : null,
                  ),
                ),
              ],
            ),
          ),
          // Action button
          _buildActionButton(percentage),
        ],
      ),
    );
  }

  Widget _buildActionButton(int percentage) {
    if (_isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.check_circle, color: AppColors.green, size: 22),
      );
    }

    if (_isDownloading) {
      return GestureDetector(
        onTap: () {
          Get.snackbar('កំពុងទាញយក', '$fileName — $percentage%',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.darkBlue,
              colorText: Colors.white,
              duration: const Duration(seconds: 1));
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.5,
                  color: downloadIconColor,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: downloadIconColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => onDownload?.call(fileName),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.file_download_outlined, color: downloadIconColor),
      ),
    );
  }
}
