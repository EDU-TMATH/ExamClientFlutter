class ContestProblemItem {
  final String code;
  final String title;
  final int order;
  final int points;
  final double timeLimit;
  final int memoryLimit;

  ContestProblemItem({
    required this.code,
    required this.title,
    required this.order,
    required this.points,
    required this.timeLimit,
    required this.memoryLimit,
  });

  factory ContestProblemItem.fromJson(Map<String, dynamic> json) {
    return ContestProblemItem(
      code: json['code'],
      title: json['title'],
      order: json['order'],
      points: json['points'],
      timeLimit: (json['time_limit'] as num).toDouble(),
      memoryLimit: json['memory_limit'],
    );
  }
}

class ProblemDetail extends ContestProblemItem {
  final String statement;
  final List<String> allowedLanguages;
  final Map<String, dynamic> ioMethod;

  ProblemDetail({
    required super.code,
    required super.title,
    required super.order,
    required super.points,
    required super.timeLimit,
    required super.memoryLimit,
    required this.statement,
    required this.allowedLanguages,
    required this.ioMethod,
  });

  factory ProblemDetail.fromJson(Map<String, dynamic> json) {
    return ProblemDetail(
      code: json['code'],
      title: json['title'],
      order: json['order'],
      points: json['points'],
      timeLimit: (json['time_limit'] as num).toDouble(),
      memoryLimit: json['memory_limit'],
      statement: json['statement'],
      allowedLanguages: List<String>.from(json['allowed_languages']),
      ioMethod: Map<String, dynamic>.from(json['io_method']),
    );
  }
}
