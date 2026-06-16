import 'dart:convert';
import 'package:e_doc_redo/data/models/document/type_document.dart';
import 'package:e_doc_redo/data/repositories/document/type_document_repository.dart';
import 'package:flutter/services.dart';

class MockTypeDocumentRepository implements TypeDocumentRepository {
  @override
  Future<List<TypeDocumentModel>> getTypes() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Load documents.json to compute real counts per type
    final docsString =
        await rootBundle.loadString('lib/data/mock_data/documents.json');
    final docsDecoded = jsonDecode(docsString) as Map<String, dynamic>;

    final typeCounts = <String, int>{};
    for (final key in docsDecoded.keys) {
      final list = docsDecoded[key];
      typeCounts[key.toString()] = (list is List) ? list.length : 0;
    }

    // Load type_documents.json for labels/id mapping
    final typeJsonString =
        await rootBundle.loadString('lib/data/mock_data/type_documents.json');
    final typeDecoded = jsonDecode(typeJsonString) as Map<String, dynamic>;
    final typeList = typeDecoded['type_documents'] as List<dynamic>;

    return typeList.map((item) {
      final m = item as Map<String, dynamic>;
      final type = m['type']?.toString() ?? '';
      // Compute count from real documents data; fallback to hardcoded
      final computedCount = typeCounts[type] ?? (m['totalDocs'] ?? 0);
      return TypeDocumentModel(
        id: m['id'] ?? 0,
        title: m['title']?.toString() ?? '',
        totalDocs: computedCount,
        type: type,
      );
    }).toList();
  }
}
