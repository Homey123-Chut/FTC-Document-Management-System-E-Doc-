import 'package:flutter/material.dart';

/// Centralized file-extension helpers used across upload and file-display
/// widgets.  Keeps icon, colour, and type-detection logic in one place so
/// it never drifts out of sync.
class FileExtension {
  FileExtension._();

  // ── Constants ──────────────────────────────────────────────────────────

  static const imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'};
  static const documentExtensions = {'pdf', 'doc', 'docx'};
  static const spreadsheetExtensions = {'xls', 'xlsx', 'csv'};

  // ── Type checks ────────────────────────────────────────────────────────

  /// Returns `true` when [ext] represents a viewable image format.
  static bool isImage(String ext) =>
      imageExtensions.contains(ext.toLowerCase());

  /// Returns `true` when [ext] represents a word-processing document.
  static bool isDocument(String ext) =>
      documentExtensions.contains(ext.toLowerCase());

  /// Returns `true` when [ext] represents a spreadsheet.
  static bool isSpreadsheet(String ext) =>
      spreadsheetExtensions.contains(ext.toLowerCase());

  // ── Visual helpers ─────────────────────────────────────────────────────

  /// Returns a Material icon appropriate for the file extension [ext].
  static IconData iconFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  /// Returns an accent colour appropriate for the file extension [ext].
  static Color colorFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return Colors.green;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  // ── Formatting ─────────────────────────────────────────────────────────

  /// Converts a raw byte [size] into a human-readable string (e.g. "2.5 MB").
  static String formatSize(int size) {
    if (size <= 0) return '';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
