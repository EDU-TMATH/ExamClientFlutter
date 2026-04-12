import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final String loadingText;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.loadingText = "Đang xác thực...",
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || onPressed == null;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isDisabled ? slate.shade(300) : sky.shade(700),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: Layout.spacing * 3.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const SizedBox(
                width: Layout.spacing * 4,
                height: Layout.spacing * 4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: Layout.spacing * 2),
            ],

            Text(
              isLoading ? loadingText : text,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
