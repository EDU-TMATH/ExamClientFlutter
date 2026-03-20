import 'package:exam_client_flutter/features/auth/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/constants/app_color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleLogin(String username, String password) {
    // Handle login logic here
    print("Logging in with username: $username and password: $password");
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
          child: LoginForm(),
        ),
      ),
    );
  }
}
