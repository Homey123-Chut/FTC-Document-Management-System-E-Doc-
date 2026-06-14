// ignore_for_file: unnecessary_cast

import 'dart:convert';

import 'package:e_doc_redo/data/models/approval_workflow/approval_workflow.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';
import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/data/repositories/document/document_detail_repository.dart';
import 'package:flutter/services.dart';

/// Mock implementation of [DocumentDetailRepository].
/// Combines data from outgoing_documents.json + approval_workflow.json + user.json.
class DocumentDetailRepositoryImpl implements DocumentDetailRepository {
  static const _outgoingPath = 'lib/data/mock_data/outgoing_documents.json';
  static const _workflowPath = 'lib/data/mock_data/approval_workflow.json';
  static const _userPath = 'lib/data/mock_data/user.json';

  List<OutgoingDocumentModel>? _cachedOutgoing;
  List<ApprovalWorkflowModel>? _cachedWorkflows;
  List<UserModel>? _cachedUsers;

  static Map<String, dynamic> _toStringKeyMap(Map map) {
    return map.map((k, v) => MapEntry(k.toString(), v));
  }

  Future<List<OutgoingDocumentModel>> _loadOutgoing() async {
    if (_cachedOutgoing != null) return _cachedOutgoing!;
    final jsonString = await rootBundle.loadString(_outgoingPath);
    final decoded = jsonDecode(jsonString);
    final docs = <OutgoingDocumentModel>[];
    if (decoded is List) {
      for (final item in decoded) {
        if (item is Map) {
          docs.add(OutgoingDocumentModel.fromJson(
              _toStringKeyMap(item)));
        }
      }
    }
    _cachedOutgoing = docs;
    return docs;
  }

  Future<List<ApprovalWorkflowModel>> _loadWorkflows() async {
    if (_cachedWorkflows != null) return _cachedWorkflows!;
    final jsonString = await rootBundle.loadString(_workflowPath);
    final decoded = jsonDecode(jsonString);
    final workflows = <ApprovalWorkflowModel>[];
    if (decoded is Map && decoded.containsKey('workflows')) {
      for (final item in decoded['workflows']) {
        if (item is Map) {
          workflows.add(ApprovalWorkflowModel.fromJson(
              _toStringKeyMap(item)));
        }
      }
    }
    _cachedWorkflows = workflows;
    return workflows;
  }

  Future<List<UserModel>> _loadUsers() async {
    if (_cachedUsers != null) return _cachedUsers!;
    final jsonString = await rootBundle.loadString(_userPath);
    final decoded = jsonDecode(jsonString);
    final users = <UserModel>[];
    if (decoded is Map && decoded.containsKey('users')) {
      for (final item in decoded['users']) {
        if (item is Map) {
          users.add(UserModel.fromJson(_toStringKeyMap(item)));
        }
      }
    }
    _cachedUsers = users;
    return users;
  }

  @override
  Future<OutgoingDocumentModel?> getOutgoingDocumentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final docs = await _loadOutgoing();
    for (final doc in docs) {
      if (doc.id == id) return doc;
    }
    return null;
  }

  @override
  Future<List<ApprovalWorkflowModel>> getWorkflows() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _loadWorkflows();
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final users = await _loadUsers();
    for (final user in users) {
      if (user.id == id) return user;
    }
    return null;
  }
}
