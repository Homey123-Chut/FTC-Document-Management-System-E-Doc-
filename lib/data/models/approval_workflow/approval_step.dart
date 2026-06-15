class ApprovalStepModel {
  final int stepNumber;
  final String level;
  final String flowLevel;
  final String status; // "pending" | "approved" | "rejected"
  final String? actionDate;

  const ApprovalStepModel({
    required this.stepNumber,
    required this.level,
    required this.flowLevel,
    this.status = 'pending',
    this.actionDate,
  });

  factory ApprovalStepModel.fromJson(Map<String, dynamic> json) {
    return ApprovalStepModel(
      stepNumber: json['stepNumber'] ?? 0,
      level: json['level']?.toString() ?? '',
      flowLevel: json['flowLevel']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      actionDate: json['actionDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'level': level,
      'flowLevel': flowLevel,
      'status': status,
      'actionDate': actionDate,
    };
  }

  ApprovalStepModel copyWith({
    int? stepNumber,
    String? level,
    String? flowLevel,
    String? status,
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

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
