import 'dart:convert';

import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/data/repositories/document/incoming_document_repository.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/repositories_impl/send_document_repository_impl.dart';
import 'package:flutter/services.dart';

/// Mock implementation of [IncomingDocumentRepository].
/// Shares the same in-memory cache as [SendDocumentRepositoryImpl]
/// so that outgoing and incoming views stay in sync.
class IncomingDocumentRepositoryImpl implements IncomingDocumentRepository {
  static const _assetPath = 'lib/data/mock_data/outgoing_documents.json';

  List<OutgoingDocumentModel>? get _cache => SendDocumentRepositoryImpl.cachedDocs;
  set _cache(List<OutgoingDocumentModel>? val) {
    SendDocumentRepositoryImpl.cachedDocs = val;
  }

  Future<List<OutgoingDocumentModel>> _loadAll() async {
    if (_cache != null) return _cache!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString);
    final docs = <OutgoingDocumentModel>[];
    if (decoded is List) {
      for (final item in decoded) {
        if (item is Map) {
          docs.add(OutgoingDocumentModel.fromJson(
              item.map((k, v) => MapEntry(k.toString(), v))));
        }
      }
    }
    _cache = docs;
    return _cache!;
  }

  @override
  Future<List<OutgoingDocumentModel>> getIncomingDocuments() async {
    final all = await _loadAll();
    return all.toList();
  }

  @override
  Future<OutgoingDocumentModel?> getDocumentById(String id) async {
    final all = await _loadAll();
    for (final doc in all) {
      if (doc.id.toString() == id) return doc;
    }
    return null;
  }

  @override
  Future<OutgoingDocumentModel> approveStep(String documentId) async {
    final all = await _loadAll();
    final idx = all.indexWhere((d) => d.id.toString() == documentId);
    if (idx == -1) throw Exception('Document not found: $documentId');

    final doc = all[idx];
    final steps = List<ApprovalStepModel>.from(doc.workflowSteps);

    final stepIdx = steps.indexWhere((s) => s.isPending);
    if (stepIdx == -1) throw Exception('No pending step to approve');

    final now = DateTime.now().toIso8601String();
    steps[stepIdx] = steps[stepIdx].copyWith(
      status: ApprovalStatus.approved,
      actionDate: now,
    );

    final newStatus = _calculateOverallStatus(steps);

    final updated = doc.copyWith(
      workflowSteps: steps,
      status: newStatus,
    );

    all[idx] = updated;
    _cache = all;
    return updated;
  }

  @override
  Future<OutgoingDocumentModel> rejectStep(String documentId,
      {String? comment}) async {
    final all = await _loadAll();
    final idx = all.indexWhere((d) => d.id.toString() == documentId);
    if (idx == -1) throw Exception('Document not found: $documentId');

    final doc = all[idx];
    final steps = List<ApprovalStepModel>.from(doc.workflowSteps);

    final stepIdx = steps.indexWhere((s) => s.isPending);
    if (stepIdx == -1) throw Exception('No pending step to reject');

    final now = DateTime.now().toIso8601String();
    steps[stepIdx] = steps[stepIdx].copyWith(
      status: ApprovalStatus.rejected,
      actionDate: now,
    );

    final updated = doc.copyWith(
      workflowSteps: steps,
      status: 'បដិសេធ',
    );

    all[idx] = updated;
    _cache = all;
    return updated;
  }

  /// Calculates overall document status from step statuses.
  /// - If any step is rejected → 'បដិសេធ'
  /// - If all steps are approved → 'បានអនុម័ត'
  /// - Otherwise → 'កំពុងរង់ចាំ'
  String _calculateOverallStatus(List<ApprovalStepModel> steps) {
    if (steps.any((s) => s.isRejected)) return 'បដិសេធ';
    if (steps.every((s) => s.isApproved)) return 'បានអនុម័ត';
    return 'កំពុងរង់ចាំ';
  }
}
