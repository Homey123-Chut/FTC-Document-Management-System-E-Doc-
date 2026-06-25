import 'dart:convert';

import 'package:e_doc_redo/core/utils/document_type_extension.dart';
import 'package:e_doc_redo/data/models/document/document_summary.dart';
import 'package:e_doc_redo/data/repositories/document/total_document_repository.dart';
import 'package:flutter/services.dart';

class TotalDocumentRepositoryImpl implements TotalDocumentRepository {
  @override
  Future<List<DocumentSummaryModel>> getTotals() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final jsonString = await rootBundle.loadString('lib/data/mock_data/documents.json');
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    final allDocs = <Map<String, dynamic>>[];
    for (final key in decoded.keys) {
      final list = decoded[key];
      if (list is List) {
        for (final item in list) {
          if (item is Map) allDocs.add(item as Map<String, dynamic>);
        }
      }
    }

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
      DocumentSummaryModel(
        id: 1,
        title: 'ឯកសារសរុប',
        count: total,
        type: 'all',
      ),
      DocumentSummaryModel(
        id: 2,
        title: 'កំពុងរង់ចាំ',
        count: pending,
        type: 'pending',
      ),
      DocumentSummaryModel(
        id: 3,
        title: 'បានអនុម័ត',
        count: approved,
        type: 'approved',
      ),
      DocumentSummaryModel(
        id: 4,
        title: 'បានបដិសេធ',
        count: rejected,
        type: 'rejected',
      ),
    ];
  }
}
