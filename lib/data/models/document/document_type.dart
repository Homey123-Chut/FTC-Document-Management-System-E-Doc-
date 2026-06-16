import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:flutter/material.dart';

enum DocumentType { personal, general, incoming, outgoing }

// ─── Document Status Enum ────────────────────────────────────────────────────

enum DocumentStatus { pending, approved, rejected }

extension DocumentStatusX on DocumentStatus {
  String get khmerTitle {
    switch (this) {
      case DocumentStatus.pending:
        return 'កំពុងរងចាំ';
      case DocumentStatus.approved:
        return 'អនុម័ត';
      case DocumentStatus.rejected:
        return 'បដិសេធ';
    }
  }

  IconData get icon {
    switch (this) {
      case DocumentStatus.pending:
        return Icons.schedule;
      case DocumentStatus.approved:
        return Icons.check_circle;
      case DocumentStatus.rejected:
        return Icons.cancel;
    }
  }

  /// Returns [bg, text, icon] color map for the status badge.
  Map<String, Color> get colors {
    switch (this) {
      case DocumentStatus.pending:
        return {
          'bg': const Color(0xFFFFFBEB),
          'text': const Color(0xFFD97706),
          'icon': const Color(0xFFF59E0B),
        };
      case DocumentStatus.approved:
        return {
          'bg': const Color(0xFFECFDF5),
          'text': const Color(0xFF059669),
          'icon': const Color(0xFF10B981),
        };
      case DocumentStatus.rejected:
        return {
          'bg': const Color(0xFFFEF2F2),
          'text': const Color(0xFFDC2626),
          'icon': const Color(0xFFEF4444),
        };
    }
  }

  /// Parses either English or Khmer status string into [DocumentStatus].
  /// Defaults to [DocumentStatus.pending] for null or unknown values.
  static DocumentStatus fromString(String? status) {
    if (status == null) return DocumentStatus.pending;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'កំពុងរងចាំ':
      case 'កំពុងរង់ចាំ': // support both spellings
        return DocumentStatus.pending;
      case 'approved':
      case 'អនុម័ត':
      case 'បានអនុម័ត': // support both spellings
        return DocumentStatus.approved;
      case 'rejected':
      case 'បដិសេធ':
        return DocumentStatus.rejected;
      default:
        return DocumentStatus.pending;
    }
  }
}

// ─── Approval Status Enum (step-level) ────────────────────────────────────────

enum ApprovalStatus { pending, approved, rejected }

extension ApprovalStatusX on ApprovalStatus {
  String get khmerTitle {
    switch (this) {
      case ApprovalStatus.pending:
        return 'កំពុងរងចាំ';
      case ApprovalStatus.approved:
        return 'អនុម័ត';
      case ApprovalStatus.rejected:
        return 'បដិសេធ';
    }
  }

  IconData get icon {
    switch (this) {
      case ApprovalStatus.pending:
        return Icons.schedule;
      case ApprovalStatus.approved:
        return Icons.check_circle;
      case ApprovalStatus.rejected:
        return Icons.cancel;
    }
  }

  Map<String, Color> get colors {
    switch (this) {
      case ApprovalStatus.pending:
        return {
          'bg': const Color(0xFFFFFBEB),
          'text': const Color(0xFFD97706),
          'icon': const Color(0xFFF59E0B),
        };
      case ApprovalStatus.approved:
        return {
          'bg': const Color(0xFFECFDF5),
          'text': const Color(0xFF059669),
          'icon': const Color(0xFF10B981),
        };
      case ApprovalStatus.rejected:
        return {
          'bg': const Color(0xFFFEF2F2),
          'text': const Color(0xFFDC2626),
          'icon': const Color(0xFFEF4444),
        };
    }
  }

  bool get isPending => this == ApprovalStatus.pending;
  bool get isApproved => this == ApprovalStatus.approved;
  bool get isRejected => this == ApprovalStatus.rejected;

  static ApprovalStatus fromString(String? status) {
    if (status == null) return ApprovalStatus.pending;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'កំពុងរងចាំ':
      case 'កំពុងរង់ចាំ':
        return ApprovalStatus.pending;
      case 'approved':
      case 'អនុម័ត':
      case 'បានអនុម័ត':
        return ApprovalStatus.approved;
      case 'rejected':
      case 'បដិសេធ':
        return ApprovalStatus.rejected;
      default:
        return ApprovalStatus.pending;
    }
  }
}

// ─── Document Type Extension ─────────────────────────────────────────────────

extension DocumentTypeX on DocumentType {
  String get khmerTitle {
    switch (this) {
      case DocumentType.personal:
        return 'ឯកសារផ្ទាល់ខ្លួន';
      case DocumentType.general:
        return 'ឯកសារទូទៅ';
      case DocumentType.incoming:
        return 'ឯកសារចូល';
      case DocumentType.outgoing:
        return 'ឯកសារចេញ';
    }
  }

  IconData get icon {
    switch (this) {
      case DocumentType.personal:
        return Icons.person_outline;
      case DocumentType.general:
        return Icons.description_outlined;
      case DocumentType.incoming:
        return Icons.move_to_inbox_outlined;
      case DocumentType.outgoing:
        return Icons.send_outlined;
    }
  }

  Color get color {
    switch (this) {
      case DocumentType.personal:
        return AppColors.lightBlue;
      case DocumentType.general:
        return AppColors.blue;
      case DocumentType.incoming:
        return AppColors.green;
      case DocumentType.outgoing:
        return AppColors.darkBlue;
    }
  }

  static DocumentType fromString(String type) {
    switch (type) {
      case 'personal':
        return DocumentType.personal;
      case 'general':
        return DocumentType.general;
      case 'incoming':
        return DocumentType.incoming;
      case 'outgoing':
        return DocumentType.outgoing;
      default:
        return DocumentType.general;
    }
  }
}
