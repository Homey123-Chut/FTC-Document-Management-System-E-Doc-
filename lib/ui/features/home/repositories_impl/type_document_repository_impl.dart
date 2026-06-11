import 'dart:convert';
import 'package:e_doc_redo/data/models/document/type_document.dart';
import 'package:e_doc_redo/data/repositories/document/type_document_repository.dart';
import 'package:flutter/services.dart';

class MockTypeDocumentRepository implements TypeDocumentRepository {
  @override
  Future<List<TypeDocumentModel>> getTypes() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final jsonString =
        await rootBundle.loadString('lib/data/mock_data/type_documents.json');
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = decoded['type_documents'] as List<dynamic>;

    return list
        .map((item) =>
            TypeDocumentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
