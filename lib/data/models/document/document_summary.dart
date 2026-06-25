
class DocumentSummaryModel {
  final int id;
  final String title;
  final int count;
  final String type;

  const DocumentSummaryModel({
    required this.id,
    required this.title,
    required this.count,
    required this.type,
  });

  factory DocumentSummaryModel.fromJson(Map<String, dynamic> json) {
    return DocumentSummaryModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      count: json['totalDocs'] ?? 0,
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalDocs': count,
      'type': type,
    };
  }
}
