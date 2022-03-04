import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/auth_service.dart';

class AuthMiddleware extends QMiddleware {
  final authService = Get.find<AuthService>();
  @override
  Future<String?> redirectGuard(String path) async {
    if (authService.isAuth) {
      return null;
    }
    return '/login';
  }
}
