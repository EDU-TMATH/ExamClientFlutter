class ContestProblemItem {
  final String code;
  final String name;
  final int order;
  final double points;
  final bool partial;
  final int? maxSubmissions;
  final String? label;

  ContestProblemItem({
    required this.code,
    required this.name,
    required this.order,
    required this.points,
    required this.partial,
    this.maxSubmissions,
    this.label,
  });

  String get title => name;

  factory ContestProblemItem.fromJson(Map<String, dynamic> json) {
    return ContestProblemItem(
      code: json['code'] ?? '',
      name: json['name'] ?? json['title'] ?? '',
      order: json['order'] ?? 0,
      points: (json['points'] as num?)?.toDouble() ?? 0,
      partial: json['partial'] ?? false,
      maxSubmissions: json['max_submissions'],
      label: json['label'],
    );
  }
}

class ProblemDetail extends ContestProblemItem {
  final String statement;
  final List<String> allowedLanguages;
  final Map<String, dynamic> ioMethod;
  final double timeLimit;
  final int memoryLimit;

  ProblemDetail({
    required super.code,
    required super.name,
    required super.order,
    required super.points,
    required super.partial,
    super.maxSubmissions,
    super.label,
    required this.statement,
    required this.allowedLanguages,
    required this.ioMethod,
    required this.timeLimit,
    required this.memoryLimit,
  });

  factory ProblemDetail.fromJson(Map<String, dynamic> json) {
    return ProblemDetail(
      code: json['code'] ?? '',
      name: json['name'] ?? json['title'] ?? '',
      order: json['order'] ?? 0,
      points: (json['points'] as num?)?.toDouble() ?? 0,
      partial: json['partial'] ?? false,
      maxSubmissions: json['max_submissions'],
      label: json['label'],
      statement: json['statement'] ?? '',
      allowedLanguages: List<String>.from(
        json['allowed_languages'] ?? const [],
      ),
      ioMethod: Map<String, dynamic>.from(json['io_method'] ?? const {}),
      timeLimit: (json['time_limit'] as num?)?.toDouble() ?? 0,
      memoryLimit: json['memory_limit'] ?? 0,
    );
  }
}

class SubmitProblemResponse {
  final String detail;
  final int submissionId;
  final bool replacedExisting;

  SubmitProblemResponse({
    required this.detail,
    required this.submissionId,
    required this.replacedExisting,
  });

  factory SubmitProblemResponse.fromJson(Map<String, dynamic> json) {
    return SubmitProblemResponse(
      detail: json['detail'] ?? 'Submitted successfully',
      submissionId: json['submission_id'] ?? json['id'] ?? 0,
      replacedExisting: json['replaced_existing'] ?? false,
    );
  }
}
