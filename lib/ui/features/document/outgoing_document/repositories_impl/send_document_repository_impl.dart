// ignore_for_file: unnecessary_cast

import 'dart:convert';

import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/data/repositories/document/send_document_repository.dart';
import 'package:flutter/services.dart';

/// Mock implementation of [SendDocumentRepository].
/// Reads/writes outgoing_documents.json via rootBundle + in-memory cache.
class SendDocumentRepositoryImpl implements SendDocumentRepository {
  static const _assetPath = 'lib/data/mock_data/outgoing_documents.json';

  static List<OutgoingDocumentModel>? _cachedDocs;

  Future<List<OutgoingDocumentModel>> _loadAll() async {
    if (_cachedDocs != null) return _cachedDocs!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw Exception(
          'outgoing_documents.json: expected a List at root, got ${decoded.runtimeType}');
    }

    final docs = <OutgoingDocumentModel>[];
    for (final item in decoded) {
      if (item is! Map) {
        throw Exception(
            'outgoing_documents.json: expected Map item, got ${item.runtimeType}');
      }
      docs.add(OutgoingDocumentModel.fromJson(
          _toStringKeyMap(item as Map)));
    }

    _cachedDocs = docs;
    return _cachedDocs!;
  }

  static Map<String, dynamic> _toStringKeyMap(Map map) {
    return map.map((k, v) => MapEntry(k.toString(), v));
  }

  @override
  Future<List<OutgoingDocumentModel>> fetchOutgoingDocuments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _loadAll();
  }

  @override
  Future<void> saveOutgoingDocument(OutgoingDocumentModel doc) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    all.add(doc);
    _cachedDocs = all;
  }

  @override
  Future<OutgoingDocumentModel?> getOutgoingDocumentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    for (final doc in all) {
      if (doc.id == id) return doc;
    }
    return null;
  }
}
