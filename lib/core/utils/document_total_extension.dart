import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

// ============================================================================
// DocumentStatsType — aggregate summary categories on the home dashboard
// ============================================================================

/// Aggregate document-count categories displayed in the stats grid
/// on the home screen (all / pending / approved / rejected).
///
/// This is **not** the same as [DocumentStatus] which tracks the status
/// of an individual document (pending / approved / rejected / draft / sent).
enum DocumentStatsType { all, pending, approved, rejected }

extension DocumentTotalExtension on DocumentStatsType {
  /// Khmer label shown on the [TotalDocumentCard].
  String get khmerTitle {
    switch (this) {
      case DocumentStatsType.all:
        return 'ឯកសារទាំងអស់';
      case DocumentStatsType.pending:
        return 'កំពុងរងចាំ';
      case DocumentStatsType.approved:
        return 'បានអនុម័ត';
      case DocumentStatsType.rejected:
        return 'បដិសេធ';
    }
  }

  /// Icon rendered inside the coloured circle on the [TotalDocumentCard].
  IconData get icon {
    switch (this) {
      case DocumentStatsType.all:
        return Icons.description;
      case DocumentStatsType.pending:
        return Icons.hourglass_empty;
      case DocumentStatsType.approved:
        return Icons.library_add_check;
      case DocumentStatsType.rejected:
        return Icons.cancel_outlined;
    }
  }

  /// Background colour of the icon circle on the [TotalDocumentCard].
  Color get color {
    switch (this) {
      case DocumentStatsType.all:
        return AppColors.darkBlue;
      case DocumentStatsType.pending:
        return AppColors.yellow;
      case DocumentStatsType.approved:
        return AppColors.green;
      case DocumentStatsType.rejected:
        return AppColors.red;
    }
  }

  /// Parse a string returned by the API (e.g. `"all"`, `"pending"`)
  /// into a typed enum value.  Falls back to [DocumentStatsType.all].
  static DocumentStatsType fromString(String type) {
    switch (type) {
      case 'all':
        return DocumentStatsType.all;
      case 'pending':
        return DocumentStatsType.pending;
      case 'approved':
        return DocumentStatsType.approved;
      case 'rejected':
        return DocumentStatsType.rejected;
      default:
        return DocumentStatsType.all;
    }
  }
}
