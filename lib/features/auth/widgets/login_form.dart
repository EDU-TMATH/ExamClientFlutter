import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_client_flutter/core/exceptions/app_exception.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/widgets/app_button.dart';
import 'package:exam_client_flutter/widgets/app_input.dart';
import 'package:exam_client_flutter/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoggingIn = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void submit() async {
    if (isLoggingIn) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoggingIn = true;
    });

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(usernameController.text, passwordController.text);

      if (!mounted) return;

      context.go('/');
    } on AppException catch (e) {
      if (!mounted) return;
      AppToast.error(context, e.message);
    } finally {
      if (mounted) {
        setState(() {
          isLoggingIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Layout.spacing * 2.5,
                  vertical: Layout.spacing * 1.25,
                ),
                decoration: BoxDecoration(
                  color: sky.shade(50),
                  borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
                  border: Border.all(color: sky.shade(200)),
                ),
                child: Text(
                  "Nền tảng lập trình thi đấu",
                  style: TextStyle(
                    fontSize: Layout.textXs,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: sky.shade(800),
                  ),
                ),
              ),
              const SizedBox(height: Layout.spacing * 3),
              Text(
                "TMATH Workspace",
                style: TextStyle(
                  fontSize: Layout.text_3xl,
                  fontWeight: FontWeight.w800,
                  color: slate.shade(900),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: Layout.spacing * 1),
              Text(
                "Đăng nhập để vào khu vực làm bài với tốc độ nhanh, giao diện tập trung và ổn định.",
                style: TextStyle(
                  fontSize: Layout.textSm,
                  color: slate.shade(500),
                  height: 1.45,
                ),
              ),
            ],
          ),
          const SizedBox(height: Layout.spacing * 5),
          // Username
          AppInput(
            hint: "Tên đăng nhập",
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: Layout.spacing * 4),

          // Password
          AppInput(
            hint: "Mật khẩu",
            controller: passwordController,
            isPassword: true,
          ),
          const SizedBox(height: Layout.spacing * 5),

          Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 16,
                color: sky.shade(700),
              ),
              const SizedBox(width: Layout.spacing * 1.5),
              Expanded(
                child: Text(
                  "Kết nối bảo mật, phiên đăng nhập được mã hóa.",
                  style: TextStyle(
                    fontSize: Layout.textXs,
                    color: slate.shade(500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Layout.spacing * 3),

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
