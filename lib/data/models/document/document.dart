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
  final int? folderId;
  final int? typeDocumentId;
  final String? workflowId;
  final String? createdBy;
  final String? createdDate;
  final String? workflowCode;
  final String? documentFlow;
  final String? sender;
  final String? priority;

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
    this.folderId,
    this.typeDocumentId,
    this.workflowId,
    this.createdBy,
    this.createdDate,
    this.workflowCode,
    this.documentFlow,
    this.sender,
    this.priority,
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
      attachedFile: _attachmentText(json['attachedFile']),
      folderId: json['folderId'],
      typeDocumentId: json['typeDocumentId'],
      workflowId: json['workflowId']?.toString(),
      createdBy: json['createdBy']?.toString(),
      createdDate: json['createdDate']?.toString(),
      workflowCode: json['workflowCode']?.toString(),
      documentFlow: json['documentFlow']?.toString(),
      sender: json['sender']?.toString(),
      priority: json['priority']?.toString(),
    );
  }

  static String _attachmentText(dynamic value) {
    if (value is List) {
      return value.whereType<String>().join(', ');
    }
    return value?.toString() ?? '';
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
      'folderId': folderId,
      'typeDocumentId': typeDocumentId,
      'workflowId': workflowId,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'workflowCode': workflowCode,
      'documentFlow': documentFlow,
      'sender': sender,
      'priority': priority,
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
    int? folderId,
    int? typeDocumentId,
    String? workflowId,
    String? createdBy,
    String? createdDate,
    String? workflowCode,
    String? documentFlow,
    String? sender,
    String? priority,
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
      folderId: folderId ?? this.folderId,
      typeDocumentId: typeDocumentId ?? this.typeDocumentId,
      workflowId: workflowId ?? this.workflowId,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      workflowCode: workflowCode ?? this.workflowCode,
      documentFlow: documentFlow ?? this.documentFlow,
      sender: sender ?? this.sender,
      priority: priority ?? this.priority,
    );
  }
}
