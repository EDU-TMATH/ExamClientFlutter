import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/di.dart';
import 'package:exam_client_flutter/widgets/app_button.dart';
import 'package:exam_client_flutter/widgets/app_input.dart';
import 'package:exam_client_flutter/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoggingIn = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void submit() async {
    if (isLoggingIn) return;
    setState(() {
      isLoggingIn = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        final tokenResponse = await authService.login(
          usernameController.text,
          passwordController.text,
        );
        // print("Login successful: ${tokenResponse.accessToken}");
        await tokenStorage.saveToken(tokenResponse.accessToken);
        if (!mounted) return;
        context.go('/contests');
      } catch (e) {
        // Handle login error
        AppToast.show(context, e.toString());
      } finally {
        if (mounted) {
          setState(() {
            isLoggingIn = false;
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                "EXAM CLIENT",
                style: TextStyle(
                  fontSize: Layout.text_sm,
                  fontWeight: FontWeight.w500,
                  color: sky.shade(600),
                ),
              ),
              const SizedBox(height: Layout.spacing * 2),
              Text(
                "Đăng nhập",
                style: TextStyle(
                  fontSize: Layout.text_3xl,
                  fontWeight: FontWeight.bold,
                  color: slate.shade(900),
                ),
              ),
              const SizedBox(height: Layout.spacing * 1),
              Text(
                "Nhập tài khoản để bắt đầu làm bài thi.",
                style: TextStyle(
                  fontSize: Layout.text_sm,
                  color: slate.shade(500),
                ),
              ),
            ],
          ),
          const SizedBox(height: Layout.spacing * 4),
          // Username
          AppInput(hint: "Tên đăng nhập", controller: usernameController),
          const SizedBox(height: Layout.spacing * 4),

          // Password
          AppInput(
            hint: "Mật khẩu",
            controller: passwordController,
            isPassword: true,
          ),
          const SizedBox(height: Layout.spacing * 5),

          // Button
          AppButton(
            text: "Đăng nhập",
            onPressed: submit,
            isLoading: isLoggingIn,
          ),
        ],
      ),
    );
  }
}
