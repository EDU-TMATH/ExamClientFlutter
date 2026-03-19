import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || onPressed == null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? sky.shade(300) : sky.shade(600),

          padding: const EdgeInsets.symmetric(vertical: Layout.spacing * 4),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Layout.border_radius_xl),
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
              isLoading ? "Đang xác thực..." : text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
