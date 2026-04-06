class ContestListItem {
  final String key;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final double? timeLimit;
  final bool isRated;
  final bool isPrivate;
  final bool isOrganizationPrivate;
  final List<String> tags;
  final bool canJoin;
  final bool canViewTasks;
  final bool isInContest;

  ContestListItem({
    required this.key,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.timeLimit,
    required this.isRated,
    required this.isPrivate,
    required this.isOrganizationPrivate,
    required this.tags,
    required this.canJoin,
    required this.canViewTasks,
    required this.isInContest,
  });

  String get title => name;

  factory ContestListItem.fromJson(Map<String, dynamic> json) {
    return ContestListItem(
      key: json['key'],
      name: json['name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      timeLimit: (json['time_limit'] as num?)?.toDouble(),
      isRated: json['is_rated'] ?? false,
      isPrivate: json['is_private'] ?? false,
      isOrganizationPrivate: json['is_organization_private'] ?? false,
      tags: List<String>.from(json['tags'] ?? const []),
      canJoin: json['can_join'] ?? false,
      canViewTasks: json['can_view_tasks'] ?? false,
      isInContest: json['is_in_contest'] ?? false,
    );
  }
}

class ContestDetailResponse extends ContestListItem {
  final String description;
  final String scoreboardVisibility;
  final bool hiddenScoreboard;
  final List<int> organizations;
  final List<String> authors;
  final bool currentUserInContest;
  final bool canSeeRankings;
  final bool canSeeProblems;
  final List<ContestProblemSummary> problems;

  ContestDetailResponse({
    required super.key,
    required super.name,
    required super.startTime,
    required super.endTime,
    required super.timeLimit,
    required super.isRated,
    required super.isPrivate,
    required super.isOrganizationPrivate,
    required super.tags,
    required super.canJoin,
    required super.canViewTasks,
    required super.isInContest,
    required this.description,
    required this.scoreboardVisibility,
    required this.hiddenScoreboard,
    required this.organizations,
    required this.authors,
    required this.currentUserInContest,
    required this.canSeeRankings,
    required this.canSeeProblems,
    required this.problems,
  });

  factory ContestDetailResponse.fromJson(Map<String, dynamic> json) {
    return ContestDetailResponse(
      key: json['key'],
      name: json['name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      timeLimit: (json['time_limit'] as num?)?.toDouble(),
      isRated: json['is_rated'] ?? false,
      isPrivate: json['is_private'] ?? false,
      isOrganizationPrivate: json['is_organization_private'] ?? false,
      tags: List<String>.from(json['tags'] ?? const []),
      canJoin: json['can_join'] ?? false,
      canViewTasks: json['can_view_tasks'] ?? false,
      isInContest: json['is_in_contest'] ?? false,
      description: json['description'],
      scoreboardVisibility: json['scoreboard_visibility'] ?? '',
      hiddenScoreboard: json['hidden_scoreboard'] ?? false,
      organizations: List<int>.from(json['organizations'] ?? const []),
      authors: List<String>.from(json['authors'] ?? const []),
      currentUserInContest: json['current_user_in_contest'] ?? false,
      canSeeRankings: json['can_see_rankings'] ?? false,
      canSeeProblems: json['can_see_problems'] ?? false,
      problems: List<ContestProblemSummary>.from(
        (json['problems'] ?? const []).map(
          (x) => ContestProblemSummary.fromJson(x),
        ),
      ),
    );
  }
}

class ContestResponse {
  final String? key;

  ContestResponse({this.key});

  bool get hasContest => key != null;

  factory ContestResponse.fromJson(Map<String, dynamic> json) {
    return ContestResponse(key: json['key'] as String?);
  }
}

class ContestProblemSummary {
  final String? label;
  final String code;
  final String name;
  final int order;
  final double points;
  final bool partial;
  final int? maxSubmissions;

  ContestProblemSummary({
    required this.label,
    required this.code,
    required this.name,
    required this.order,
    required this.points,
    required this.partial,
    required this.maxSubmissions,
  });

  factory ContestProblemSummary.fromJson(Map<String, dynamic> json) {
    return ContestProblemSummary(
      label: json['label'],
      code: json['code'],
      name: json['name'],
      order: json['order'] ?? 0,
      points: (json['points'] as num?)?.toDouble() ?? 0,
      partial: json['partial'] ?? false,
      maxSubmissions: json['max_submissions'],
    );
  }
}
