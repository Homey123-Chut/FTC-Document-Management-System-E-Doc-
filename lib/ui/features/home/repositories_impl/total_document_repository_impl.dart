import 'dart:convert';

import 'package:e_doc_redo/data/models/document/total_document.dart';
import 'package:e_doc_redo/data/repositories/document/total_document_repository.dart';
import 'package:flutter/services.dart';

class MockTotalDocumentRepository implements TotalDocumentRepository {
  @override
  Future<List<TotalDocumentModel>> getTotals() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final jsonString =
        await rootBundle.loadString('lib/data/mock_data/total_documents.json');
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    // Convert stats map to a single TotalDocumentModel for display
    return [
      TotalDocumentModel(
        id: 1,
        title: 'ឯកសារសរុប',
        totalDocs: (decoded['all'] as int?) ?? 0,
        type: 'all',
      ),
      TotalDocumentModel(
        id: 2,
        title: 'កំពុងរង់ចាំ',
        totalDocs: (decoded['pending'] as int?) ?? 0,
        type: 'pending',
      ),
      TotalDocumentModel(
        id: 3,
        title: 'បានអនុម័ត',
        totalDocs: (decoded['approved'] as int?) ?? 0,
        type: 'approved',
      ),
      TotalDocumentModel(
        id: 4,
        title: 'បានបដិសេធ',
        totalDocs: (decoded['rejected'] as int?) ?? 0,
        type: 'rejected',
      ),
    ];
  }
}
