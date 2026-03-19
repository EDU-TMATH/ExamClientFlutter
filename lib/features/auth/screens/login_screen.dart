import 'package:exam_client_flutter/core/di.dart';
import 'package:exam_client_flutter/widgets/app_button.dart';
import 'package:exam_client_flutter/widgets/app_input.dart';
import 'package:exam_client_flutter/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        print("Login successful: ${tokenResponse.accessToken}");
        await tokenStorage.saveToken(tokenResponse.accessToken);
        if (!mounted) return;
        context.go('/contests');
      } catch (e) {
        // Handle login error
        AppToast.show(context, e.toString());
      } finally {
        if (!mounted) return;
        setState(() {
          isLoggingIn = false;
        });
      }
    }
    setState(() {
      isLoggingIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Login")),
      backgroundColor: gray.shade(200),
      body: Center(
        child: Container(
          width: 28 * Layout.rem,
          padding: const EdgeInsets.all(Layout.spacing * 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Layout.border_radius_3xl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          ),
          child: Form(
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
          ),
        ),
      ),
    );
  }
}
