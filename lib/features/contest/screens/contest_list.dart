import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/contest/models/contest.dart';
import 'package:exam_client_flutter/features/contest/widgets/contest_card.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContestList extends ConsumerStatefulWidget {
  const ContestList({super.key});

  @override
  ConsumerState<ContestList> createState() => _ContestListState();
}

class _ContestListState extends ConsumerState<ContestList> {
  List<ContestListItem> contests = [];
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchContests();
  }

  Future<void> fetchContests() async {
    try {
      final contestService = ref.read(contestServiceProvider);
      final data = await contestService.fetchContests();
      setState(() {
        contests = data;
      });
    } catch (e) {
      // print("Error fetching contests: $e");
      setState(() {
        error = "Không tải được danh sách cuộc thi";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Danh sách cuộc thi",
      subtitle: "Theo dõi thời gian bắt đầu và vào thi ngay khi sẵn sàng.",
      activeRoute: "/contests",
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
      );
    }

    if (error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Layout.spacing * 4),
          child: Text(error, style: TextStyle(color: red.shade(600))),
        ),
      );
    }

    if (contests.isEmpty) {
      return const Center(child: Text("Chưa có cuộc thi nào."));
    }

    return RefreshIndicator(
      onRefresh: fetchContests,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 1200
              ? 3
              : width >= 768
              ? 2
              : 1;

          final mainAxisExtent = crossAxisCount == 1 ? 220.0 : 260.0;

          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              Layout.spacing * 3,
              Layout.spacing * 3,
              Layout.spacing * 3,
              Layout.spacing * 4,
            ),
            itemCount: contests.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: Layout.spacing * 2,
              mainAxisSpacing: Layout.spacing * 2,
              mainAxisExtent: mainAxisExtent,
            ),
            itemBuilder: (context, index) => ContestCard(
              contest: contests[index],
              onJoin: (key) {
                context.go('/contest/$key');
              },
            ),
          );
        },
      ),
    );
  }
}
