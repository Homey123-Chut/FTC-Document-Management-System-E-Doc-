/// Lightweight reference to a created document used in Step 1 dropdown.
class DocumentReferenceModel {
  final int id;
  final String documentNumber;
  final String titleKhmer;
  final String type; // personal, general, incoming

  const DocumentReferenceModel({
    required this.id,
    required this.documentNumber,
    required this.titleKhmer,
    required this.type,
  });

  factory DocumentReferenceModel.fromJson(Map<String, dynamic> json) {
    return DocumentReferenceModel(
      id: json['id'] ?? 0,
      documentNumber: json['documentNumber']?.toString() ?? '',
      titleKhmer: json['titleKhmer']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentNumber': documentNumber,
      'titleKhmer': titleKhmer,
      'type': type,
    };
  }

  /// Display string for the dropdown: "លេខ: 001 — ចំណងជើងឯកសារ"
  String get displayText => 'លេខ: $documentNumber — $titleKhmer';
}
