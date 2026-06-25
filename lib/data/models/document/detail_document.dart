import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';
import 'package:e_doc_redo/data/models/document/outgoing_document_model.dart';

class DetailDocumentModel {
  final OutgoingDocumentModel document;
  final String creatorName;
  final String creatorDepartment;
  final String creatorProfileImg;
  final String creatorRole;
  final List<String> attachedFiles;
  final List<ApprovalStepModel> approvalSteps;
  final String workflowName;
  final int totalSteps;
  final String workflowDescription;
  final String receiverName;
  final String receiverDepartment;
  final String receiverRole;
  /// Map of successfully downloaded files: fileName → localPath.
  final Map<String, String> downloadedFiles;

  const DetailDocumentModel({
    required this.document,
    required this.creatorName,
    required this.creatorDepartment,
    required this.creatorProfileImg,
    required this.creatorRole,
    required this.attachedFiles,
    required this.approvalSteps,
    required this.workflowName,
    required this.totalSteps,
    required this.workflowDescription,
    required this.receiverName,
    required this.receiverDepartment,
    required this.receiverRole,
    this.downloadedFiles = const {},
  });

  factory DetailDocumentModel.fromJson(Map<String, dynamic> json) {
    final rawDoc = json['document'];
    final document = rawDoc is Map
        ? OutgoingDocumentModel.fromJson(
            rawDoc.map((k, v) => MapEntry(k.toString(), v)))
        : OutgoingDocumentModel(
            id: 0,
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

    final rawDownloaded = json['downloadedFiles'];
    final Map<String, String> downloadedFiles;
    if (rawDownloaded is Map) {
      downloadedFiles = rawDownloaded.map((k, v) => MapEntry(k.toString(), v.toString()));
    } else {
      downloadedFiles = {};
    }

    return DetailDocumentModel(
      document: document,
      creatorName: json['creatorName']?.toString() ?? '',
      creatorDepartment: json['creatorDepartment']?.toString() ?? '',
      creatorProfileImg: json['creatorProfileImg']?.toString() ?? '',
      creatorRole: json['creatorRole']?.toString() ?? '',
      attachedFiles: attachedFiles.cast<String>(),
      approvalSteps: approvalSteps.cast<ApprovalStepModel>(),
      workflowName: json['workflowName']?.toString() ?? '',
      totalSteps: json['totalSteps'] ?? 0,
      workflowDescription: json['workflowDescription']?.toString() ?? '',
      receiverName: json['receiverName']?.toString() ?? '',
      receiverDepartment: json['receiverDepartment']?.toString() ?? '',
      receiverRole: json['receiverRole']?.toString() ?? '',
      downloadedFiles: downloadedFiles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document': document.toJson(),
      'creatorName': creatorName,
      'creatorDepartment': creatorDepartment,
      'creatorProfileImg': creatorProfileImg,
      'creatorRole': creatorRole,
      'attachedFiles': attachedFiles,
      'approvalSteps': approvalSteps.map((s) => s.toJson()).toList(),
      'workflowName': workflowName,
      'totalSteps': totalSteps,
      'workflowDescription': workflowDescription,
      'receiverName': receiverName,
      'receiverDepartment': receiverDepartment,
      'receiverRole': receiverRole,
      'downloadedFiles': downloadedFiles,
    };
  }
}
