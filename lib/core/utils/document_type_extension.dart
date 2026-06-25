import 'package:e_doc_redo/core/theme/theme.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/views/workflow_approval_screen.dart';
import 'package:e_doc_redo/ui/features/document/document_type/views/document_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Unified document-type enumeration used for:
/// - filtering documents (personal, general, incoming, outgoing)
/// - "quick action" cards on the home screen (all six values)
///
/// Metadata (Khmer title, icon, colour, navigation target) lives in the
/// [DocumentTypeX] extension so there is exactly **one** place to update
/// when a new type is added.
enum DocumentType {
  personal,
  general,
  incoming,
  outgoing,
  workflow,
  department,
}

enum DocumentStatus { pending, approved, rejected, draft, sent }

extension DocumentStatusX on DocumentStatus {
  String get khmerTitle {
    switch (this) {
      case DocumentStatus.pending:
        return 'កំពុងរងចាំ';
      case DocumentStatus.approved:
        return 'អនុម័ត';
      case DocumentStatus.rejected:
        return 'បដិសេធ';
      case DocumentStatus.draft:
        return 'ពង្រៀង';
      case DocumentStatus.sent:
        return 'បានផ្ញើ';
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
      case DocumentStatus.draft:
        return Icons.edit_note;
      case DocumentStatus.sent:
        return Icons.send;
    }
  }

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
      case DocumentStatus.draft:
        return {
          'bg': const Color(0xFFF1F5F9),
          'text': const Color(0xFF475569),
          'icon': const Color(0xFF64748B),
        };
      case DocumentStatus.sent:
        return {
          'bg': const Color(0xFFEFF6FF),
          'text': const Color(0xFF1D4ED8),
          'icon': const Color(0xFF3B82F6),
        };
    }
  }

  bool get isDraft => this == DocumentStatus.draft;
  bool get isSent => this == DocumentStatus.sent;

  static DocumentStatus fromString(String? status) {
    if (status == null) return DocumentStatus.pending;
    switch (status.toLowerCase()) {
      case 'pending':
      case 'កំពុងរងចាំ':
      case 'កំពុងរង់ចាំ':
        return DocumentStatus.pending;
      case 'approved':
      case 'អនុម័ត':
      case 'បានអនុម័ត':
        return DocumentStatus.approved;
      case 'rejected':
      case 'បដិសេធ':
        return DocumentStatus.rejected;
      case 'draft':
      case 'ពង្រៀង':
        return DocumentStatus.draft;
      case 'sent':
      case 'បានផ្ញើ':
        return DocumentStatus.sent;
      default:
        return DocumentStatus.pending;
    }
  }
}

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

extension DocumentTypeX on DocumentType {
  // ── Single source of truth for all document-type metadata ──────────

  String get khmerTitle {
    switch (this) {
      case DocumentType.personal:
        return 'ឯកសារផ្ទាល់ខ្លួន';
      case DocumentType.incoming:
        return 'ឯកសារចូល';
      case DocumentType.outgoing:
        return 'ឯកសារចេញ';
      case DocumentType.general:
        return 'ឯកសារទូទៅ';
      case DocumentType.workflow:
        return 'លំហូរឯកសារ';
      case DocumentType.department:
        return 'អង្គភាព';
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
      case DocumentType.workflow:
        return Icons.account_tree_outlined;
      case DocumentType.department:
        return Icons.business_outlined;
    }
  }

  Color get color {
    switch (this) {
      case DocumentType.personal:
        return AppColors.darkBlue;
      case DocumentType.incoming:
        return AppColors.green;
      case DocumentType.outgoing:
        return AppColors.red;
      case DocumentType.general:
        return AppColors.blue;
      case DocumentType.workflow:
        return AppColors.yellow;
      case DocumentType.department:
        return AppColors.grey;
    }
  }

  bool get isDocumentCategory {
    switch (this) {
      case DocumentType.personal:
      case DocumentType.general:
      case DocumentType.incoming:
      case DocumentType.outgoing:
        return true;
      case DocumentType.workflow:
      case DocumentType.department:
        return false;
    }
  }

  
  void navigate() {
    if (!isDocumentCategory) {
      switch (this) {
        case DocumentType.workflow:
          Get.to(() => const WorkflowApprovalScreen());
          return;
        case DocumentType.department:
          Get.to(() => DocumentListScreen(type: DocumentType.general));
          return;
        default:
          break;
      }
    }
    Get.to(() => DocumentListScreen(type: this));
  }

  static const List<DocumentType> documentCategories = [
    DocumentType.personal,
    DocumentType.incoming,
    DocumentType.outgoing,
    DocumentType.general,
  ];

  static const List<DocumentType> allTypes = [
    DocumentType.personal,
    DocumentType.incoming,
    DocumentType.outgoing,
    DocumentType.general,
    DocumentType.workflow,
    DocumentType.department,
  ];


  static DocumentType fromString(String type) {
    switch (type) {
      case 'personal':
        return DocumentType.personal;
      case 'incoming':
        return DocumentType.incoming;
      case 'outgoing':
        return DocumentType.outgoing;
      case 'general':
        return DocumentType.general;
      case 'workflow':
        return DocumentType.workflow;
      case 'department':
        return DocumentType.department;
      default:
        return DocumentType.general;
    }
  }
}
