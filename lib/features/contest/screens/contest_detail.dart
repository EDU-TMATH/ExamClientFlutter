import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class ContestDetail extends StatefulWidget {
  const ContestDetail({super.key});

  @override
  State<ContestDetail> createState() => _ContestDetailState();
}

class _ContestDetailState extends State<ContestDetail> {
  @override
  void initState() {
    super.initState();
    // TODO: Fetch contest details here
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Chi tiết cuộc thi",
      subtitle: "Xem thông tin tổng quan và thao tác quản trị cuộc thi.",
      activeRoute: "/contests",
      headerAction: ElevatedButton(
        onPressed: () {
          // TODO: Implement edit contest functionality
        },
        child: const Text("Chỉnh sửa"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
            "Tên cuộc thi: ...",
            style: TextStyle(
              fontSize: Layout.text_lg,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Layout.spacing * 2),
          Text(
            "Mô tả cuộc thi:\n...",
            style: TextStyle(fontSize: Layout.text_base),
          ),
        ],
      ),
    );
  }
}
