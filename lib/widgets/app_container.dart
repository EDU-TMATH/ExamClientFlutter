import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AppContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  double _getMaxWidth(double width) {
    if (width >= 1536) return 1536;
    if (width >= 1280) return 1280;
    if (width >= 1024) return 1024;
    if (width >= 768) return 768;
    if (width >= 640) return 640;
    return width; // mobile full
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = _getMaxWidth(constraints.maxWidth);

        return Center(
          child: SizedBox(
            width: maxWidth,
            child: Padding(padding: padding, child: child),
          ),
        );
      },
    );
  }
}
