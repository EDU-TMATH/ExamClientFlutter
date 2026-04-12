import 'package:flutter/material.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/constants/app_color.dart';

class AppInput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  const AppInput({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.hint,
        hintText: widget.hint,
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Layout.spacing * 4,
          vertical: Layout.spacing * 3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: gray.shade(300)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: gray.shade(300)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          borderSide: BorderSide(color: sky.shade(700), width: 1.4),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nhập ${widget.hint.toLowerCase()}";
        }
        return null;
      },
    );
  }
}
