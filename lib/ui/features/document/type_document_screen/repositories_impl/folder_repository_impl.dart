// ignore_for_file: unnecessary_cast

import 'dart:convert';

import 'package:e_doc_redo/data/models/document/folder.dart';
import 'package:e_doc_redo/data/repositories/document/folder_repository.dart';
import 'package:flutter/services.dart';

/// Local mock implementation of [FolderRepository].
/// Reads from folders.json structure:
///   { "personal": [...], "general": [...], "incoming": [...], "outgoing": [...] }
class FolderRepositoryImpl implements FolderRepository {
  static const _assetPath = 'lib/data/mock_data/folders.json';

  Map<String, List<FolderModel>>? _cachedByType;

  Future<Map<String, List<FolderModel>>> _loadAll() async {
    if (_cachedByType != null) return _cachedByType!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString);

    if (decoded is! Map) {
      throw Exception('folders.json: expected a Map at root, got ${decoded.runtimeType}');
    }

    final map = <String, List<FolderModel>>{};
    for (final key in (decoded as Map).keys) {
      final rawList = (decoded as Map)[key];
      if (rawList is! List) {
        throw Exception('folders.json: expected List for key "$key", got ${rawList.runtimeType}');
      }
      final folders = <FolderModel>[];
      for (final item in rawList) {
        if (item is! Map) {
          throw Exception('folders.json: expected Map item in "$key", got ${item.runtimeType}');
        }
        folders.add(FolderModel.fromJson(_toStringKeyMap(item)));
      }
      map[key.toString()] = folders;
    }

    _cachedByType = map;
    return _cachedByType!;
  }

  /// Converts a map whose keys may not be Strings (common with dart2js JSON)
  /// into a proper Map<String, dynamic>.
  static Map<String, dynamic> _toStringKeyMap(Map map) {
    return map.map((k, v) => MapEntry(k.toString(), v));
  }

  @override
  Future<List<FolderModel>> getFolders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    return all.values.expand((folders) => folders).toList();
  }

  @override
  Future<List<FolderModel>> getFoldersByType(String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    return List<FolderModel>.from(all[type] ?? <FolderModel>[]);
  }

  @override
  Future<FolderModel> getFolderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    for (final folders in all.values) {
      for (final f in folders) {
        if (f.id == id) return f;
      }
    }
    throw Exception('Folder not found: $id');
  }

  @override
  Future<void> addFolder(FolderModel folder, String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    final current = List<FolderModel>.from(all[type] ?? <FolderModel>[]);
    // Insert at index 0 so newly created folders appear at the top.
    current.insert(0, folder);
    all[type] = current;
    _cachedByType = all;
  }

  @override
  Future<void> updateFolder(FolderModel folder) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = await _loadAll();
    for (final entry in all.entries) {
      final idx = entry.value.indexWhere((f) => f.id == folder.id);
      if (idx != -1) {
        final updated = List<FolderModel>.from(entry.value);
        updated[idx] = folder;
        all[entry.key] = updated;
        _cachedByType = all;
        return;
      }
    }
  }
}
