class User {
  final int id;
  final String username;
  final String displayName;
  final String rank;
  final double points;
  final double performancePoints;
  final int problemCount;
  final int? rating;
  final String? currentContestKey;
  final bool isStaff;
  final bool isSuperuser;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.rank,
    required this.points,
    required this.performancePoints,
    required this.problemCount,
    required this.rating,
    required this.currentContestKey,
    required this.isStaff,
    required this.isSuperuser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      displayName: json['display_name'] ?? '',
      rank: json['rank'] ?? '',
      points: (json['points'] as num?)?.toDouble() ?? 0,
      performancePoints: (json['performance_points'] as num?)?.toDouble() ?? 0,
      problemCount: json['problem_count'] ?? 0,
      rating: json['rating'],
      currentContestKey: json['current_contest_key'],
      isStaff: json['is_staff'] ?? false,
      isSuperuser: json['is_superuser'] ?? false,
    );
  }
}
