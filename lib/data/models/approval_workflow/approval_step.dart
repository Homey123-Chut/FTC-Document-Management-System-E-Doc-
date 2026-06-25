import 'package:e_doc_redo/core/utils/document_type_extension.dart';

class ApprovalStepModel {
  final int stepNumber;
  final String level;
  final String flowLevel;
  final ApprovalStatus status;
  final String? actionDate;

  const ApprovalStepModel({
    required this.stepNumber,
    required this.level,
    required this.flowLevel,
    this.status = ApprovalStatus.pending,
    this.actionDate,
  });

  factory ApprovalStepModel.fromJson(Map<String, dynamic> json) {
    return ApprovalStepModel(
      stepNumber: json['stepNumber'] ?? 0,
      level: json['level']?.toString() ?? '',
      flowLevel: json['flowLevel']?.toString() ?? '',
      status: ApprovalStatusX.fromString(json['status']?.toString()),
      actionDate: json['actionDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'level': level,
      'flowLevel': flowLevel,
      'status': status.name,
      'actionDate': actionDate,
    };
  }

  ApprovalStepModel copyWith({
    int? stepNumber,
    String? level,
    String? flowLevel,
    ApprovalStatus? status,
    String? actionDate,
  }) {
    return ApprovalStepModel(
      stepNumber: stepNumber ?? this.stepNumber,
      level: level ?? this.level,
      flowLevel: flowLevel ?? this.flowLevel,
      status: status ?? this.status,
      actionDate: actionDate ?? this.actionDate,
    );
  }

  bool get isPending => status == ApprovalStatus.pending;
  bool get isApproved => status == ApprovalStatus.approved;
  bool get isRejected => status == ApprovalStatus.rejected;
}
