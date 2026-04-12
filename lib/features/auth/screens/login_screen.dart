import 'package:exam_client_flutter/features/auth/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/constants/app_color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cardMaxWidth = size.width < 640 ? double.infinity : 30 * Layout.rem;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black.withValues(alpha: 0.48),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -100,
              child: _GlowOrb(size: 280, color: sky.shade(500)),
            ),
            Positioned(
              bottom: -90,
              left: -70,
              child: _GlowOrb(size: 220, color: blue.shade(500)),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Layout.spacing * 4,
                    vertical: Layout.spacing * 6,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: Container(
                      padding: const EdgeInsets.all(Layout.spacing * 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(
                          Layout.borderRadius3xl,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 34,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: const LoginForm(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.5),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
