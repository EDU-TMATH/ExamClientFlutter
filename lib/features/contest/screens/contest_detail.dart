import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/contest/models/contest.dart';
import 'package:exam_client_flutter/features/contest/models/problem.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContestDetail extends ConsumerStatefulWidget {
  final String contestKey;

  const ContestDetail({super.key, required this.contestKey});

  @override
  ConsumerState<ContestDetail> createState() => _ContestDetailState();
}

class _ContestDetailState extends ConsumerState<ContestDetail> {
  ContestDetailResponse? detail;
  List<ContestProblemItem> problems = [];
  bool loadingDetail = true;
  bool joining = false;
  bool joined = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadContest();
  }

  Future<void> _loadContest() async {
    setState(() {
      loadingDetail = true;
      error = '';
    });

    try {
      final contestService = ref.read(contestServiceProvider);
      final data = await contestService.fetchContestDetail(widget.contestKey);

      if (!mounted) return;
      setState(() {
        detail = data;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Khong tai duoc thong tin cuoc thi';
      });
    } finally {
      if (mounted) {
        setState(() {
          loadingDetail = false;
        });
      }
    }
  }

  Future<void> _joinAndLoadProblems() async {
    if (joining) return;

    setState(() {
      joining = true;
      error = '';
    });

    try {
      final contestService = ref.read(contestServiceProvider);
      await contestService.joinContest(widget.contestKey);
      final data = await contestService.fetchContestProblems(widget.contestKey);

      if (!mounted) return;
      setState(() {
        joined = true;
        problems = data;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Khong the tai danh sach bai tap';
      });
    } finally {
      if (mounted) {
        setState(() {
          joining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: detail?.name ?? 'Contest: ${widget.contestKey}',
      subtitle: 'Xem chi tiet cuoc thi va danh sach bai tap.',
      activeRoute: '/contests',
      breadcrumbLabel: 'Danh sach cuoc thi',
      onBreadcrumbTap: () {
        context.go('/contests');
      },
      headerAction: ElevatedButton(
        onPressed: joining ? null : _joinAndLoadProblems,
        child: Text(joining ? 'Dang tai bai...' : 'Tai bai thi'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loadingDetail) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty && detail == null) {
      return Center(child: Text(error));
    }

    final d = detail;
    if (d == null) {
      return const Center(child: Text('Khong co du lieu cuoc thi'));
    }

    return Padding(
      padding: const EdgeInsets.all(Layout.spacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d.description),
          const SizedBox(height: Layout.spacing * 2),
          if (error.isNotEmpty)
            Text(error, style: TextStyle(color: red.shade(600))),
          const SizedBox(height: Layout.spacing * 2),
          const Text(
            'Danh sach bai tap',
            style: TextStyle(
              fontSize: Layout.textLg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Layout.spacing * 2),
          Expanded(
            child: !joined
                ? const Center(
                    child: Text('Nhan "Tai bai thi" de lay danh sach bai.'),
                  )
                : problems.isEmpty
                ? const Center(child: Text('Chua co bai tap'))
                : ListView.separated(
                    itemCount: problems.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: Layout.spacing * 1.5),
                    itemBuilder: (context, index) {
                      final p = problems[index];
                      return Card(
                        child: ListTile(
                          title: Text('${p.code} - ${p.title}'),
                          subtitle: Text('${p.points} diem'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context.go(
                              '/contest/${widget.contestKey}/${p.code}',
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
