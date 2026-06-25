class LevelWorkflowModel {
  final int? id;
  final String name;

  LevelWorkflowModel({
    this.id,
    required this.name,
  });

  factory LevelWorkflowModel.fromJson(Map<String, dynamic> json) {
    return LevelWorkflowModel(
      id: json['id'],
      name: json['name']?.toString() ?? '',
    );
  }

  factory LevelWorkflowModel.fromString(String name) {
    return LevelWorkflowModel(name: name);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
