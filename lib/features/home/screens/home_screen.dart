import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/home/services/home_service.dart';
import 'package:exam_client_flutter/features/home/widgets/home_dashboard_view.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  HomeDashboardData? dashboard;
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      final service = ref.read(homeServiceProvider);
      final data = await service.fetchDashboard();

      if (!mounted) return;
      setState(() {
        dashboard = data;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Không thể tải dashboard lúc này.';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Trang chủ',
      subtitle:
          'Control center cho luyện tập, review và contest. Một phần block đang dùng sample chờ API dashboard.',
      activeRoute: '/',
      headerAction: FilledButton.tonalIcon(
        onPressed: _loadData,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Làm mới'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Text(
          error,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final data = dashboard;
    if (data == null) {
      return const Center(child: Text('Không có dữ liệu dashboard'));
    }

    return HomeDashboardView(data: data);
  }
}
