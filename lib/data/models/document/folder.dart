class FolderModel {
  final String id;
  final String title;
  final int documentCount;

  const FolderModel({
    required this.id,
    required this.title,
    required this.documentCount,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      documentCount: json['documentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'documentCount': documentCount,
    };
  }

  FolderModel copyWith({
    String? id,
    String? title,
    int? documentCount,
  }) {
    return FolderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      documentCount: documentCount ?? this.documentCount,
    );
  }
}
