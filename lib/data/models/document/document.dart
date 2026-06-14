class DocumentModel {
  final int id;
  final String titleKhmer;
  final String titleLatin;
  final String documentNumber;
  final String date;
  final String status;
  final String subject;
  final String program;
  final String documentHistory;
  final String attachedFile;

  const DocumentModel({
    required this.id,
    required this.titleKhmer,
    required this.titleLatin,
    required this.documentNumber,
    required this.date,
    required this.status,
    required this.subject,
    required this.program,
    required this.documentHistory,
    required this.attachedFile,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? 0,
      titleKhmer: json['titleKhmer']?.toString() ?? '',
      titleLatin: json['titleLatin']?.toString() ?? '',
      documentNumber: json['documentNumber']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      program: json['program']?.toString() ?? '',
      documentHistory: json['documentHistory']?.toString() ?? '',
      attachedFile: json['attachedFile']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKhmer': titleKhmer,
      'titleLatin': titleLatin,
      'documentNumber': documentNumber,
      'date': date,
      'status': status,
      'subject': subject,
      'program': program,
      'documentHistory': documentHistory,
      'attachedFile': attachedFile,
    };
  }

  DocumentModel copyWith({
    int? id,
    String? titleKhmer,
    String? titleLatin,
    String? documentNumber,
    String? date,
    String? status,
    String? subject,
    String? program,
    String? documentHistory,
    String? attachedFile,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      titleKhmer: titleKhmer ?? this.titleKhmer,
      titleLatin: titleLatin ?? this.titleLatin,
      documentNumber: documentNumber ?? this.documentNumber,
      date: date ?? this.date,
      status: status ?? this.status,
      subject: subject ?? this.subject,
      program: program ?? this.program,
      documentHistory: documentHistory ?? this.documentHistory,
      attachedFile: attachedFile ?? this.attachedFile,
    );
  }
}
