import 'package:flutter/material.dart';

class AppToast {
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    final animation = Tween<Offset>(
      begin: const Offset(1, 0), // 👈 từ phải
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    final fade = Tween<double>(begin: 0, end: 1).animate(controller);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        right: 16,
        child: SlideTransition(
          position: animation,
          child: FadeTransition(
            opacity: fade,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // 👇 animation vào
    controller.forward();

    // 👇 delay rồi animation ra
    Future.delayed(duration, () async {
      await controller.reverse(); // 👈 trượt ra phải
      entry.remove();
      controller.dispose();
    });
  }
}
