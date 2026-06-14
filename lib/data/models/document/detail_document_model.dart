import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';

/// Aggregated model for the detail document screen.
/// Combines outgoing document data with user and workflow information.
class DetailDocumentModel {
  final OutgoingDocumentModel document;
  final String creatorName;
  final String creatorDepartment;
  final List<String> attachedFiles;
  final List<ApprovalStepModel> approvalSteps;
  final String workflowName;
  final int totalSteps;

  const DetailDocumentModel({
    required this.document,
    required this.creatorName,
    required this.creatorDepartment,
    required this.attachedFiles,
    required this.approvalSteps,
    required this.workflowName,
    required this.totalSteps,
  });

  factory DetailDocumentModel.fromJson(Map<String, dynamic> json) {
    final rawDoc = json['document'];
    final document = rawDoc is Map
        ? OutgoingDocumentModel.fromJson(
            rawDoc.map((k, v) => MapEntry(k.toString(), v)))
        : OutgoingDocumentModel(
            id: '',
            sourceDocumentId: 0,
            documentNumber: '',
            titleKhmer: '',
            titleLatin: '',
            date: '',
            subject: '',
            program: '',
            attachedFile: '',
            workflowTemplateId: '',
            workflowTemplateName: '',
            totalSteps: 0,
            workflowSteps: [],
            status: '',
            createdAt: '',
            createdBy: '',
          );

    final rawFiles = json['attachedFiles'];
    final List<String> attachedFiles;
    if (rawFiles is List) {
      attachedFiles = rawFiles.whereType<String>().toList();
    } else {
      attachedFiles = [];
    }

    final rawSteps = json['approvalSteps'];
    final List<dynamic> approvalSteps;
    if (rawSteps is List) {
      approvalSteps = rawSteps
          .whereType<Map>()
          .map((s) => ApprovalStepModel.fromJson(
              s.map((k, v) => MapEntry(k.toString(), v))))
          .toList();
    } else {
      approvalSteps = [];
    }

    return DetailDocumentModel(
      document: document,
      creatorName: json['creatorName']?.toString() ?? '',
      creatorDepartment: json['creatorDepartment']?.toString() ?? '',
      attachedFiles: attachedFiles.cast<String>(),
      approvalSteps: approvalSteps.cast<ApprovalStepModel>(),
      workflowName: json['workflowName']?.toString() ?? '',
      totalSteps: json['totalSteps'] ?? 0,
    );
  }
}
