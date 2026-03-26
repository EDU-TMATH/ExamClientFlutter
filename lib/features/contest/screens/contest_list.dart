import 'dart:async';

import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/di.dart';
import 'package:exam_client_flutter/features/contest/models/contest.dart';
import 'package:exam_client_flutter/features/contest/widgets/contest_card.dart';
import 'package:exam_client_flutter/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContestList extends StatefulWidget {
  const ContestList({super.key});

  @override
  State<ContestList> createState() => _ContestListState();
}

class _ContestListState extends State<ContestList> {
  List<ContestListItem> contests = [];
  bool loading = true;
  String error = "";

  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchContests();

    // update time mỗi giây (giống Vue nowMs)
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchContests() async {
    try {
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
    return Scaffold(
      // appBar: const AppNavbar(title: "Danh sách cuộc thi"),
      body: Row(
        children: [
          const AppSidebar(activeIndex: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Layout.spacing * 4),
              child: Column(
                children: [
                  _header(),
                  const SizedBox(height: Layout.spacing * 4),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Layout.spacing * 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(Layout.border_radius_2xl),
        border: Border.all(color: Colors.white70),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Danh sách cuộc thi",
            style: TextStyle(
              fontSize: Layout.text_2xl,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Layout.spacing * 1.5),
          Text(
            "Theo dõi thời gian bắt đầu và vào thi ngay khi sẵn sàng.",
            style: TextStyle(color: slate.shade(600), fontSize: Layout.text_sm),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text("Đang tải danh sách cuộc thi..."),
          ],
        ),
      );
    }

    if (error.isNotEmpty) {
      return Center(
        child: Text(error, style: TextStyle(color: red.shade(600))),
      );
    }

    if (contests.isEmpty) {
      return const Center(child: Text("Chưa có cuộc thi nào."));
    }

    return ListView.separated(
      itemCount: contests.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => ContestCard(
        contest: contests[index],
        onJoin: (key) {
          context.go('/exam/$key');
        },
      ),
    );
  }
}
