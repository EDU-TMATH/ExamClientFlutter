import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/widgets/app_sidebar.dart';
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
    return Scaffold(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Chi tiết cuộc thi",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Implement edit contest functionality
          },
          child: const Text("Chỉnh sửa"),
        ),
      ],
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
