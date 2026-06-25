import 'package:e_doc_redo/data/models/approval_workflow/level_workflow.dart';
import 'package:e_doc_redo/ui/features/approval_workflow/services/level_workflow_service.dart';
import 'package:get/get.dart';


class LevelController extends GetxController {
  final LevelWorkflowService service;

  LevelController({
    required this.service,
  });

  final RxList<LevelWorkflowModel> levels =
      <LevelWorkflowModel>[].obs;

  final RxString selectedLevel = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLevels();
  }

  Future<void> loadLevels() async {
    final result = await service.getLevels();

    levels.assignAll(result);

    if (levels.isNotEmpty) {
      selectedLevel.value = levels.first.name;
    }
  }
  Future<void> addLevel(
    LevelWorkflowModel level,
  ) async {
    levels.insert(0, level);
  }
  Future<void> removeLevel(
    int index,
  ) async {
    levels.removeAt(index);
  }
  Future<void> clearLevels() async {
    levels.clear();
  }
  Future<void> selectLevel(
    String levelName,
  ) async {
    selectedLevel.value = levelName;
  }
}