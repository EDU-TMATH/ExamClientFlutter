import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/auth/models/user.dart';

class HomeFocusItem {
  final String title;
  final String detail;
  final double progress;
  final String metric;

  const HomeFocusItem({
    required this.title,
    required this.detail,
    required this.progress,
    required this.metric,
  });
}

class HomeRecommendedProblem {
  final String code;
  final String title;
  final String level;
  final int points;
  final String note;

  const HomeRecommendedProblem({
    required this.code,
    required this.title,
    required this.level,
    required this.points,
    required this.note,
  });
}

class HomeRecentSubmission {
  final String problemCode;
  final String title;
  final String verdict;
  final String language;
  final String relativeTime;

  const HomeRecentSubmission({
    required this.problemCode,
    required this.title,
    required this.verdict,
    required this.language,
    required this.relativeTime,
  });
}

class HomePanelNote {
  final String label;
  final String title;
  final String detail;

  const HomePanelNote({
    required this.label,
    required this.title,
    required this.detail,
  });
}

class HomeDashboardData {
  final User user;
  final List<HomeFocusItem> focusItems;
  final List<HomeRecommendedProblem> recommendedProblems;
  final List<HomeRecentSubmission> recentSubmissions;
  final List<HomePanelNote> notes;
  final DateTime generatedAt;

  const HomeDashboardData({
    required this.user,
    required this.focusItems,
    required this.recommendedProblems,
    required this.recentSubmissions,
    required this.notes,
    required this.generatedAt,
  });

  factory HomeDashboardData.sample(User user) {
    final rating = user.rating ?? 0;
    final nextRatingMilestone = rating <= 0
        ? 'Mở rating đầu tiên'
        : 'Chạm mốc ${((rating ~/ 200) + 1) * 200}';
    final solvedThisCycle = ((user.problemCount % 4) + 1).clamp(1, 4);

    return HomeDashboardData(
      user: user,
      focusItems: [
        HomeFocusItem(
          title: 'Nhịp luyện tập hôm nay',
          detail: 'Giữ tốc độ 2 bài medium + 1 lượt review editorial ngắn.',
          progress: solvedThisCycle / 4,
          metric: '$solvedThisCycle/4 mục tiêu',
        ),
        const HomeFocusItem(
          title: 'Chủ đề cần giữ nóng',
          detail: 'Prefix sum, binary search và xử lý edge case trong mảng.',
          progress: 0.68,
          metric: 'review queue',
        ),
        HomeFocusItem(
          title: 'Mục tiêu rating gần nhất',
          detail: 'Ưu tiên bài 1100–1400 để tích lũy AC ổn định trước contest.',
          progress: rating > 0 ? 0.56 : 0.3,
          metric: nextRatingMilestone,
        ),
      ],
      recommendedProblems: const [
        HomeRecommendedProblem(
          code: 'SAMPLE-A',
          title: 'Greedy checkpoint',
          level: 'EASY',
          points: 80,
          note: 'Warm-up nhanh để vào guồng trước khi làm bài dài.',
        ),
        HomeRecommendedProblem(
          code: 'SAMPLE-B',
          title: 'Binary search on answer',
          level: 'MEDIUM',
          points: 120,
          note: 'Phù hợp để ôn tối ưu điều kiện kiểm tra và biên.',
        ),
        HomeRecommendedProblem(
          code: 'SAMPLE-C',
          title: 'DP state compression',
          level: 'HARD',
          points: 180,
          note: 'Dùng làm bài stretch khi muốn đẩy performance points.',
        ),
      ],
      recentSubmissions: const [
        HomeRecentSubmission(
          problemCode: 'SUM2D',
          title: '2D Range Sum',
          verdict: 'AC',
          language: 'C++20',
          relativeTime: '12m trước',
        ),
        HomeRecentSubmission(
          problemCode: 'PATHMIN',
          title: 'Shortest Path Variant',
          verdict: 'WA',
          language: 'Python 3',
          relativeTime: '38m trước',
        ),
        HomeRecentSubmission(
          problemCode: 'KQUERY',
          title: 'Offline query practice',
          verdict: 'TLE',
          language: 'C++20',
          relativeTime: '1h trước',
        ),
      ],
      notes: [
        const HomePanelNote(
          label: 'LIVE',
          title: 'Dữ liệu thật hiện có',
          detail:
              'Tài khoản, rank, rating, điểm và contest hiện tại đang đọc từ API `me`.',
        ),
        const HomePanelNote(
          label: 'API TODO',
          title: 'Recent submissions feed',
          detail:
              'Cần endpoint để thay verdict, ngôn ngữ và thời gian nộp gần đây bằng dữ liệu thật.',
        ),
        const HomePanelNote(
          label: 'API TODO',
          title: 'Recommendation engine',
          detail:
              'Cần gợi ý bài theo tag yếu, độ khó mục tiêu và chuỗi luyện tập gần nhất.',
        ),
        const HomePanelNote(
          label: 'SAMPLE',
          title: 'Contest radar / nhắc việc',
          detail:
              'Tạm dùng sample cho thông báo dashboard cho tới khi backend có luồng riêng.',
        ),
      ],
      generatedAt: DateTime.now(),
    );
  }
}

class HomeService {
  final Dio dio;

  HomeService(this.dio);

  Future<User> fetchCurrentUser() async {
    final res = await dio.get('me');
    return User.fromJson(res.data);
  }

  Future<HomeDashboardData> fetchDashboard() async {
    final user = await fetchCurrentUser();
    return HomeDashboardData.sample(user);
  }
}
