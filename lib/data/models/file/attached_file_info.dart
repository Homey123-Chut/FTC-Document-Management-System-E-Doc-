import 'dart:typed_data';
import 'package:e_doc_redo/core/utils/file_extension.dart';

/// Metadata for a file attached by the user (picked from device or provided
/// as raw bytes).
class AttachedFileInfo {
  final String name;
  final String? path;
  final Uint8List? bytes;
  final int size;
  final String extension;

  const AttachedFileInfo({
    required this.name,
    this.path,
    this.bytes,
    this.size = 0,
    this.extension = '',
  });

  /// Convenience check: is this a viewable image?
  bool get isImage => FileExtension.isImage(extension);

  /// Human-readable size string (e.g. "2.5 MB").
  String get formattedSize => FileExtension.formatSize(size);
}
