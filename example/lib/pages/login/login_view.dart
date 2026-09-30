import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/auth_service.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.isAuth = true;
            QR.navigator.replaceLast('/dashboard');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
