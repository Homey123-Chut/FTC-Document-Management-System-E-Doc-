import 'dart:convert';

import 'package:e_doc_redo/data/models/document/document_type.dart';
import 'package:e_doc_redo/data/models/document/total_document.dart';
import 'package:e_doc_redo/data/repositories/document/total_document_repository.dart';
import 'package:flutter/services.dart';

class MockTotalDocumentRepository implements TotalDocumentRepository {
  @override
  Future<List<TotalDocumentModel>> getTotals() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Load all documents from documents.json
    final jsonString =
        await rootBundle.loadString('lib/data/mock_data/documents.json');
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    // Flatten all documents across all types
    final allDocs = <Map<String, dynamic>>[];
    for (final key in decoded.keys) {
      final list = decoded[key];
      if (list is List) {
        for (final item in list) {
          if (item is Map) allDocs.add(item as Map<String, dynamic>);
        }
      }
    }

    // Compute counts from real data using DocumentStatusX.fromString
    final total = allDocs.length;
    final pending = allDocs.where((d) {
      final s = DocumentStatusX.fromString(d['status']?.toString());
      return s == DocumentStatus.pending;
    }).length;
    final approved = allDocs.where((d) {
      final s = DocumentStatusX.fromString(d['status']?.toString());
      return s == DocumentStatus.approved;
    }).length;
    final rejected = allDocs.where((d) {
      final s = DocumentStatusX.fromString(d['status']?.toString());
      return s == DocumentStatus.rejected;
    }).length;

    return [
      TotalDocumentModel(
        id: 1,
        title: 'ឯកសារសរុប',
        totalDocs: total,
        type: 'all',
      ),
      TotalDocumentModel(
        id: 2,
        title: 'កំពុងរង់ចាំ',
        totalDocs: pending,
        type: 'pending',
      ),
      TotalDocumentModel(
        id: 3,
        title: 'បានអនុម័ត',
        totalDocs: approved,
        type: 'approved',
      ),
      TotalDocumentModel(
        id: 4,
        title: 'បានបដិសេធ',
        totalDocs: rejected,
        type: 'rejected',
      ),
    ];
  }
}
