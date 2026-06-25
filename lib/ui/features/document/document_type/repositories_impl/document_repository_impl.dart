
import 'dart:convert';

import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/data/repositories/document/document_repository.dart';
import 'package:e_doc_redo/ui/features/document/outgoing_document/repositories_impl/send_document_repository_impl.dart';
import 'package:flutter/services.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  static const _assetPath = 'lib/data/mock_data/documents.json';

  Map<String, List<DocumentModel>>? _cachedByType;

  /// Standalone cache for recently created documents (draft/pending).
  /// Shared across all repository instances so that creation and listing
  /// stay in sync without persisting to the JSON asset.
  // ignore: non_constant_identifier_names
  static List<DocumentModel>? _recentDocs;

  Future<Map<String, List<DocumentModel>>> _loadAll() async {
    if (_cachedByType != null) return _cachedByType!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! Map) {
      throw Exception('documents.json: expected a Map at root, got ${decoded.runtimeType}');
    }

    final map = <String, List<DocumentModel>>{};
    for (final key in decoded.keys) {
      final rawList = decoded[key];
      if (rawList is! List) {
        throw Exception('documents.json: expected List for key "$key", got ${rawList.runtimeType}');
      }
      final docs = <DocumentModel>[];
      for (final item in rawList) {
        if (item is! Map) {
          throw Exception('documents.json: expected Map item in "$key", got ${item.runtimeType}');
        }
        docs.add(DocumentModel.fromJson(_toStringKeyMap(item)));
      }
      map[key.toString()] = docs;
    }

    _cachedByType = map;
    return _cachedByType!;
  }

  static Map<String, dynamic> _toStringKeyMap(Map map) {
    return map.map((k, v) => MapEntry(k.toString(), v));
  }

  static String _attachmentText(dynamic value) {
    if (value is List) {
      return value.whereType<String>().join(', ');
    }
    return value?.toString() ?? '';
  }

  @override
  Future<List<DocumentModel>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    return all.values.expand((docs) => docs).toList();
  }

  @override
  Future<List<DocumentModel>> getDocumentsByType(String type) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (type == 'incoming') {
      return _loadIncomingApprovalDocs();
    }

    final all = await _loadAll();
    return List<DocumentModel>.from(all[type] ?? <DocumentModel>[]);
  }

  Future<List<DocumentModel>> _loadIncomingApprovalDocs() async {
    try {
      final cache = SendDocumentRepositoryImpl.cachedDocs;
      if (cache != null && cache.isNotEmpty) {
        return cache.map((d) => _outgoingToDocumentModel(d)).toList();
      }

      final jsonString = await rootBundle.loadString('lib/data/mock_data/outgoing_documents.json');
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];
      return decoded.whereType<Map>().map((item) {
        final map = item.map((k, v) => MapEntry(k.toString(), v));
        return DocumentModel(
          id: int.tryParse(map['id']?.toString() ?? '') ??
              (map['sourceDocumentId'] ?? 0),
          titleKhmer: map['titleKhmer']?.toString() ?? '',
          titleLatin: map['titleLatin']?.toString() ?? '',
          documentNumber: map['documentNumber']?.toString() ?? '',
          date: map['date']?.toString() ?? '',
          status: map['status']?.toString().isEmpty == false
              ? map['status']!.toString()
              : 'កំពុងរង់ចាំ',
          subject: map['subject']?.toString() ?? '',
          program: map['program']?.toString() ?? '',
          documentHistory: 'បានបញ្ជូន',
          attachedFile: _attachmentText(map['attachedFile']),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  DocumentModel _outgoingToDocumentModel(OutgoingDocumentModel d) {
    return DocumentModel(
      id: d.id,
      titleKhmer: d.titleKhmer,
      titleLatin: d.titleLatin,
      documentNumber: d.documentNumber,
      date: d.date,
      status: d.status,
      subject: d.subject,
      program: d.program,
      documentHistory: 'បានបញ្ជូន',
      attachedFile: d.attachedFile,
    );
  }

  @override
  Future<List<DocumentModel>> searchDocuments({
    required String type,
    String documentNumber = '',
    String title = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (documentNumber.isEmpty && title.isEmpty) return <DocumentModel>[];

    final docs = await getDocumentsByType(type);

    return docs.where((doc) {
      if (documentNumber.isNotEmpty &&
          !doc.documentNumber
              .toLowerCase()
              .contains(documentNumber.toLowerCase())) {
        return false;
      }
      if (title.isNotEmpty) {
        final q = title.toLowerCase();
        if (!doc.titleKhmer.toLowerCase().contains(q) &&
            !doc.titleLatin.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Future<DocumentModel> getDocumentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    for (final docs in all.values) {
      for (final d in docs) {
        if (d.id.toString() == id) return d;
      }
    }
    throw Exception('Document not found: $id');
  }

  @override
  Future<void> addDocument(DocumentModel document, String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    final current = List<DocumentModel>.from(all[type] ?? <DocumentModel>[]);
    // Insert at index 0 so newly created documents appear at the top.
    current.insert(0, document);
    all[type] = current;
    _cachedByType = all;

    // Also track as a recently-created document (draft/pending).
    final recent = List<DocumentModel>.from(_recentDocs ?? []);
    recent.insert(0, document);
    _recentDocs = recent;
  }

  // ── Recently created documents ─────────────────────────────────────

  @override
  Future<List<DocumentModel>> getRecentDocuments() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final recent = _recentDocs;
    if (recent == null) return [];
    // Return only documents that are still draft or pending (not yet sent)
    return recent
        .where((d) =>
            d.status == 'ពង្រៀង' ||
            d.status == 'កំពុងរង់ចាំ' ||
            d.status == 'draft' ||
            d.status == 'pending')
        .toList();
  }

  @override
  Future<void> sendDocuments(List<int> ids) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final recent = List<DocumentModel>.from(_recentDocs ?? []);
    for (final id in ids) {
      final idx = recent.indexWhere((d) => d.id == id);
      if (idx != -1) {
        recent[idx] = recent[idx].copyWith(status: 'បានផ្ញើ');
      }
    }
    _recentDocs = recent;

    // Also push sent documents into the outgoing cache so they appear
    // immediately in the outgoing list.
    try {
      final outgoingCache = SendDocumentRepositoryImpl.cachedDocs ?? [];
      for (final id in ids) {
        final doc = recent.firstWhere((d) => d.id == id);
        final outgoing = OutgoingDocumentModel(
          id: doc.id,
          sourceDocumentId: doc.id,
          documentNumber: doc.documentNumber,
          titleKhmer: doc.titleKhmer,
          titleLatin: doc.titleLatin,
          date: doc.date,
          subject: doc.subject,
          program: doc.program,
          attachedFile: doc.attachedFile,
          workflowTemplateId: '',
          workflowTemplateName: '',
          totalSteps: 0,
          workflowSteps: [],
          status: 'បានផ្ញើ',
          createdAt: DateTime.now().toIso8601String(),
          createdBy: doc.createdBy ?? '',
        );
        outgoingCache.add(outgoing);
      }
      SendDocumentRepositoryImpl.cachedDocs = outgoingCache;
    } catch (_) {
      // Ignore if the doc can't be converted to outgoing
    }
  }

  @override
  Future<void> updateDocument(DocumentModel document) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    for (final entry in all.entries) {
      final idx = entry.value.indexWhere((d) => d.id == document.id);
      if (idx != -1) {
        final updated = List<DocumentModel>.from(entry.value);
        updated[idx] = document;
        all[entry.key] = updated;
        _cachedByType = all;
        return;
      }
    }
  }
}
