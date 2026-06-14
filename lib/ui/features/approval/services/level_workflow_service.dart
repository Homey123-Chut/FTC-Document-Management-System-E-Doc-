import 'package:e_doc_redo/data/models/approval_workflow/level_workflow.dart';
import 'package:e_doc_redo/data/repositories/approval/workflow_level_repository.dart';


class LevelWorkflowService {
  final LevelWorkflowRepository repository;

  LevelWorkflowService(this.repository);

  Future<List<LevelWorkflowModel>> getLevels() {
    return repository.getLevels();
  }
}