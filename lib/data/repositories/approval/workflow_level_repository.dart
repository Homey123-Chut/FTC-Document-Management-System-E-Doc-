import 'package:e_doc_redo/data/models/approval_workflow/level_workflow.dart';


abstract class LevelWorkflowRepository {
  Future<List<LevelWorkflowModel>> getLevels();
}