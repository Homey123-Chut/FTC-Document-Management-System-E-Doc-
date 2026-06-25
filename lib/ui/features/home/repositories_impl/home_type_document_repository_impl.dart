import 'dart:convert';
import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/data/repositories/document/type_document_repository.dart';
import 'package:flutter/services.dart';

class HomeTypeDocumentRepositoryImpl implements TypeDocumentRepository {
  @override
  Future<List<DocumentSummaryModel>> getTypes() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final docsString = await rootBundle.loadString('lib/data/mock_data/documents.json');
    final docsDecoded = jsonDecode(docsString) as Map<String, dynamic>;

    final typeCounts = <String, int>{};
    for (final key in docsDecoded.keys) {
      final list = docsDecoded[key];
      typeCounts[key.toString()] = (list is List) ? list.length : 0;
    }

    final typeJsonString = await rootBundle.loadString('lib/data/mock_data/type_documents.json');
    final typeDecoded = jsonDecode(typeJsonString) as Map<String, dynamic>;
    final typeList = typeDecoded['type_documents'] as List<dynamic>;

    return typeList.map((item) {
      final m = item as Map<String, dynamic>;
      final type = m['type']?.toString() ?? '';
      final computedCount = typeCounts[type] ?? (m['totalDocs'] ?? 0);
      return DocumentSummaryModel(
        id: m['id'] ?? 0,
        title: m['title']?.toString() ?? '',
        count: computedCount,
        type: type,
      );
    }).toList();
  }
}
