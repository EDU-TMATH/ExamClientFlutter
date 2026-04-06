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
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.blue.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Layout.spacing * 4,
            vertical: Layout.spacing * 3,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Layout.borderRadiusXl),
            ),
            borderSide: BorderSide(color: gray.shade(300)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
            borderSide: BorderSide(color: gray.shade(300)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
            borderSide: BorderSide(color: sky.shade(500), width: 1.5),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Nhập ${widget.hint.toLowerCase()}";
          }
          return null;
        },
      ),
    );
  }
}
