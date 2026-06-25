import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
class OutgoingDocumentModel {
  final int id;
  final int sourceDocumentId;
  final String documentNumber;
  final String titleKhmer;
  final String titleLatin;
  final String date;
  final String subject;
  final String program;
  final String attachedFile;
  final String workflowTemplateId;
  final String workflowTemplateName;
  final int totalSteps;
  final List<ApprovalStepModel> workflowSteps;
  final String status;
  final String createdAt;
  final String createdBy;

  const OutgoingDocumentModel({
    required this.id,
    required this.sourceDocumentId,
    required this.documentNumber,
    required this.titleKhmer,
    required this.titleLatin,
    required this.date,
    required this.subject,
    required this.program,
    required this.attachedFile,
    required this.workflowTemplateId,
    required this.workflowTemplateName,
    required this.totalSteps,
    required this.workflowSteps,
    required this.status,
    required this.createdAt,
    required this.createdBy,
  });

  factory OutgoingDocumentModel.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['workflowSteps'];
    final List<ApprovalStepModel> steps;
    if (rawSteps is List) {
      steps = rawSteps
          .whereType<Map>()
          .map((s) => ApprovalStepModel.fromJson(_toStringKeyMap(s)))
          .toList();
    } else {
      steps = [];
    }

    return OutgoingDocumentModel(
      id: json['id'] ?? 0,
      sourceDocumentId: json['sourceDocumentId'] ?? 0,
      documentNumber: json['documentNumber']?.toString() ?? '',
      titleKhmer: json['titleKhmer']?.toString() ?? '',
      titleLatin: json['titleLatin']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      program: json['program']?.toString() ?? '',
      attachedFile: _attachmentText(json['attachedFile']),
      workflowTemplateId: json['workflowTemplateId']?.toString() ?? '',
      workflowTemplateName: json['workflowTemplateName']?.toString() ?? '',
      totalSteps: json['totalSteps'] ?? 0,
      workflowSteps: steps,
      status: json['status']?.toString().isEmpty == false
          ? json['status']!.toString()
          : 'កំពុងរង់ចាំ',
      createdAt: json['createdAt']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
    );
  }

  static String _attachmentText(dynamic value) {
    if (value is List) {
      return value.whereType<String>().join(', ');
    }
    return value?.toString() ?? '';
  }

  static Map<String, dynamic> _toStringKeyMap(Map map) {
    return map.map((k, v) => MapEntry(k.toString(), v));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceDocumentId': sourceDocumentId,
      'documentNumber': documentNumber,
      'titleKhmer': titleKhmer,
      'titleLatin': titleLatin,
      'date': date,
      'subject': subject,
      'program': program,
      'attachedFile': attachedFile,
      'workflowTemplateId': workflowTemplateId,
      'workflowTemplateName': workflowTemplateName,
      'totalSteps': totalSteps,
      'workflowSteps': workflowSteps.map((s) => s.toJson()).toList(),
      'status': status,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }

  OutgoingDocumentModel copyWith({
    int? id,
    int? sourceDocumentId,
    String? documentNumber,
    String? titleKhmer,
    String? titleLatin,
    String? date,
    String? subject,
    String? program,
    String? attachedFile,
    String? workflowTemplateId,
    String? workflowTemplateName,
    int? totalSteps,
    List<ApprovalStepModel>? workflowSteps,
    String? status,
    String? createdAt,
    String? createdBy,
  }) {
    return OutgoingDocumentModel(
      id: id ?? this.id,
      sourceDocumentId: sourceDocumentId ?? this.sourceDocumentId,
      documentNumber: documentNumber ?? this.documentNumber,
      titleKhmer: titleKhmer ?? this.titleKhmer,
      titleLatin: titleLatin ?? this.titleLatin,
      date: date ?? this.date,
      subject: subject ?? this.subject,
      program: program ?? this.program,
      attachedFile: attachedFile ?? this.attachedFile,
      workflowTemplateId: workflowTemplateId ?? this.workflowTemplateId,
      workflowTemplateName: workflowTemplateName ?? this.workflowTemplateName,
      totalSteps: totalSteps ?? this.totalSteps,
      workflowSteps: workflowSteps ?? this.workflowSteps,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
