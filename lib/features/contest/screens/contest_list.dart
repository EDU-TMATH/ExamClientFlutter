import 'package:exam_client_flutter/widgets/app_navbar.dart';
import 'package:flutter/material.dart';

class ContestList extends StatelessWidget {
  const ContestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(title: "Contest List"),
      body: const Center(child: Text('Contest List Screen')),
    );
  }
}
