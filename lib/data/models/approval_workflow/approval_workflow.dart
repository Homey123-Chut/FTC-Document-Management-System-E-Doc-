
import 'package:e_doc_redo/data/models/approval_workflow/approval_step.dart';

class ApprovalWorkflowModel {
  final String id;
  final String workflowTitleKhmer;
  final String workflowTitleLatin;
  final String description;
  final String documentType;
  final int totalDocuments;
  final int totalLevels;
  final DateTime createdAt;
  final List<ApprovalStepModel> steps;

  ApprovalWorkflowModel({
    required this.id,
    required this.workflowTitleKhmer,
    required this.workflowTitleLatin,
    required this.description,
    required this.documentType,
    required this.totalDocuments,
    required this.totalLevels,
    required this.createdAt,
    required this.steps,
  });

  factory ApprovalWorkflowModel.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'];
    final List<ApprovalStepModel> steps;
    if (rawSteps is List) {
      steps = rawSteps
          .whereType<Map>()
          .map((e) => ApprovalStepModel.fromJson(
              e.map((k, v) => MapEntry(k.toString(), v))))
          .toList();
    } else {
      steps = [];
    }

    return ApprovalWorkflowModel(
      id: json['id']?.toString() ?? '',
      workflowTitleKhmer: json['workflowTitleKhmer']?.toString() ?? '',
      workflowTitleLatin: json['workflowTitleLatin']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? '',
      totalDocuments: json['totalDocuments'] ?? 0,
      totalLevels: json['totalLevels'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      steps: steps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workflowTitleKhmer': workflowTitleKhmer,
      'workflowTitleLatin': workflowTitleLatin,
      'description': description,
      'documentType': documentType,
      'totalDocuments': totalDocuments,
      'totalLevels': totalLevels,
      'createdAt': createdAt.toIso8601String(),
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}