class TypeDocumentModel {
  final int id;
  final String title;
  final int totalDocs;
  final String type;

  TypeDocumentModel({
    required this.id,
    required this.title,
    required this.totalDocs,
    required this.type,
  });

  factory TypeDocumentModel.fromJson(Map<String, dynamic> json) {
    return TypeDocumentModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      totalDocs: json['totalDocs'] ?? 0,
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalDocs': totalDocs,
      'type': type,
    };
  }
}
