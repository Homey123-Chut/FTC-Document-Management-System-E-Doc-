import 'dart:convert';

import 'package:e_doc_redo/data/models/approval_workflow/level_workflow.dart';
import 'package:e_doc_redo/data/repositories/approval/workflow_level_repository.dart';
import 'package:flutter/services.dart';



class WorkflowLevelRepositoryImpl implements LevelWorkflowRepository {
  @override
  Future<List<LevelWorkflowModel>> getLevels() async {
    final jsonString =
        await rootBundle.loadString(
      'lib/data/mock_data/level_workflow.json',
    );

    final jsonData = jsonDecode(jsonString);

    return (jsonData['levels_workflow'] as List)
        .map(
          (e) => LevelWorkflowModel.fromJson(e),
        )
        .toList();
  }
}