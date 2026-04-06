class PracticeProblemPage {
  final List<PracticeProblemListItem> items;
  final int page;
  final int pageSize;

  const PracticeProblemPage({
    required this.items,
    required this.page,
    required this.pageSize,
  });

  bool get hasNextPage => items.length >= pageSize;
  bool get isFirstPage => page <= 1;
}

class PracticeProblemListItem {
  final String code;
  final String name;
  final String? group;
  final List<String> types;
  final double points;
  final bool partial;
  final bool isPublic;
  final bool isOrganizationPrivate;

  const PracticeProblemListItem({
    required this.code,
    required this.name,
    required this.group,
    required this.types,
    required this.points,
    required this.partial,
    required this.isPublic,
    required this.isOrganizationPrivate,
  });

  String get title => name.isNotEmpty ? name : code;

  factory PracticeProblemListItem.fromJson(Map<String, dynamic> json) {
    return PracticeProblemListItem(
      code: json['code']?.toString() ?? '',
      name: (json['name'] ?? json['title'] ?? '').toString(),
      group: json['group']?.toString(),
      types: List<String>.from(
        (json['types'] ?? const []).map((e) => e.toString()),
      ),
      points: (json['points'] as num?)?.toDouble() ?? 0,
      partial: json['partial'] ?? false,
      isPublic: json['is_public'] ?? true,
      isOrganizationPrivate: json['is_organization_private'] ?? false,
    );
  }
}

class PracticeLanguageLimit {
  final String language;
  final double timeLimit;
  final int memoryLimit;

  const PracticeLanguageLimit({
    required this.language,
    required this.timeLimit,
    required this.memoryLimit,
  });

  factory PracticeLanguageLimit.fromJson(Map<String, dynamic> json) {
    return PracticeLanguageLimit(
      language: json['language']?.toString() ?? '',
      timeLimit: (json['time_limit'] as num?)?.toDouble() ?? 0,
      memoryLimit: json['memory_limit'] ?? 0,
    );
  }
}

class PracticeLatestSubmission {
  final int id;
  final String? status;
  final String? result;
  final DateTime? date;

  const PracticeLatestSubmission({
    required this.id,
    required this.status,
    required this.result,
    required this.date,
  });

  factory PracticeLatestSubmission.fromJson(Map<String, dynamic> json) {
    return PracticeLatestSubmission(
      id: json['id'] ?? 0,
      status: json['status']?.toString(),
      result: json['result']?.toString(),
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,
    );
  }
}

class PracticeProblemDetail extends PracticeProblemListItem {
  final List<String> authors;
  final List<String> curators;
  final double timeLimit;
  final int memoryLimit;
  final bool shortCircuit;
  final List<String> allowedLanguages;
  final List<PracticeLanguageLimit> languageResourceLimits;
  final String statement;
  final Map<String, dynamic> ioMethod;
  final bool canEdit;
  final bool canSubmit;
  final List<Map<String, dynamic>> onlineJudges;
  final PracticeLatestSubmission? latestSubmission;

  const PracticeProblemDetail({
    required super.code,
    required super.name,
    required super.group,
    required super.types,
    required super.points,
    required super.partial,
    required super.isPublic,
    required super.isOrganizationPrivate,
    required this.authors,
    required this.curators,
    required this.timeLimit,
    required this.memoryLimit,
    required this.shortCircuit,
    required this.allowedLanguages,
    required this.languageResourceLimits,
    required this.statement,
    required this.ioMethod,
    required this.canEdit,
    required this.canSubmit,
    required this.onlineJudges,
    required this.latestSubmission,
  });

  factory PracticeProblemDetail.fromJson(Map<String, dynamic> json) {
    return PracticeProblemDetail(
      code: json['code']?.toString() ?? '',
      name: (json['name'] ?? json['title'] ?? '').toString(),
      group: json['group']?.toString(),
      types: List<String>.from(
        (json['types'] ?? const []).map((e) => e.toString()),
      ),
      points: (json['points'] as num?)?.toDouble() ?? 0,
      partial: json['partial'] ?? false,
      isPublic: json['is_public'] ?? true,
      isOrganizationPrivate: json['is_organization_private'] ?? false,
      authors: List<String>.from(
        (json['authors'] ?? const []).map((e) => e.toString()),
      ),
      curators: List<String>.from(
        (json['curators'] ?? const []).map((e) => e.toString()),
      ),
      timeLimit: (json['time_limit'] as num?)?.toDouble() ?? 0,
      memoryLimit: json['memory_limit'] ?? 0,
      shortCircuit: json['short_circuit'] ?? false,
      allowedLanguages: List<String>.from(
        (json['allowed_languages'] ?? const []).map((e) => e.toString()),
      ),
      languageResourceLimits: List<PracticeLanguageLimit>.from(
        (json['language_resource_limits'] ?? const []).map(
          (e) => PracticeLanguageLimit.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        ),
      ),
      statement: json['statement']?.toString() ?? '',
      ioMethod: Map<String, dynamic>.from(json['io_method'] ?? const {}),
      canEdit: json['can_edit'] ?? false,
      canSubmit: json['can_submit'] ?? false,
      onlineJudges: List<Map<String, dynamic>>.from(
        (json['online_judges'] ?? const []).map(
          (e) => Map<String, dynamic>.from(e as Map),
        ),
      ),
      latestSubmission: json['latest_submission'] == null
          ? null
          : PracticeLatestSubmission.fromJson(
              Map<String, dynamic>.from(json['latest_submission'] as Map),
            ),
    );
  }
}

class PracticeSubmitResponse {
  final String detail;
  final int? submissionId;
  final bool replacedExisting;

  const PracticeSubmitResponse({
    required this.detail,
    this.submissionId,
    this.replacedExisting = false,
  });

  factory PracticeSubmitResponse.fromJson(Map<String, dynamic> json) {
    return PracticeSubmitResponse(
      detail: (json['detail'] ?? 'Submitted successfully').toString(),
      submissionId: json['submission_id'] ?? json['id'],
      replacedExisting: json['replaced_existing'] ?? false,
    );
  }
}
