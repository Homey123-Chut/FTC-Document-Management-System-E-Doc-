// ignore_for_file: unnecessary_cast

import 'dart:convert';

import 'package:e_doc_redo/data/models/document/document.dart';
import 'package:e_doc_redo/data/repositories/document/document_repository.dart';
import 'package:flutter/services.dart';

/// Local mock implementation of [DocumentRepository] focused on search operations.
/// Reads from documents.json structure:
///   { "personal": [...], "general": [...], "incoming": [...], "outgoing": [...] }
class SearchRepositoryImpl implements DocumentRepository {
  static const _assetPath = 'lib/data/mock_data/documents.json';

  Map<String, List<DocumentModel>>? _cachedByType;

  Future<Map<String, List<DocumentModel>>> _loadAll() async {
    if (_cachedByType != null) return _cachedByType!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! Map) {
      throw Exception('documents.json: expected a Map at root, got ${decoded.runtimeType}');
    }

    final decodedMap = decoded as Map;
    final map = <String, List<DocumentModel>>{};
    for (final key in decodedMap.keys) {
      final rawList = decodedMap[key];
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

  @override
  Future<List<DocumentModel>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    return all.values.expand((docs) => docs).toList();
  }

  @override
  Future<List<DocumentModel>> getDocumentsByType(String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    return List<DocumentModel>.from(all[type] ?? <DocumentModel>[]);
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
    current.add(document);
    all[type] = current;
    _cachedByType = all;
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
