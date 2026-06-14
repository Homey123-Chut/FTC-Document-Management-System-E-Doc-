class ApprovalStepModel {
  final int stepNumber;
  final String level;
  final String flowLevel;

  ApprovalStepModel({
    required this.stepNumber,
    required this.level,
    required this.flowLevel,
  });

  factory ApprovalStepModel.fromJson(Map<String, dynamic> json) {
    return ApprovalStepModel(
      stepNumber: json['stepNumber'] ?? 0,
      level: json['level']?.toString() ?? '',
      flowLevel: json['flowLevel']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'level': level,
      'flowLevel': flowLevel,
    };
  }
}