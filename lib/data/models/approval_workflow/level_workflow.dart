class LevelWorkflowModel {
  final String name;

  LevelWorkflowModel({
    required this.name,
  });

  factory LevelWorkflowModel.fromJson(String json) {
    return LevelWorkflowModel(
      name: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
    };
  }
}