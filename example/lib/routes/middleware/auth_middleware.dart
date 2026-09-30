import 'package:qlevar_router/qlevar_router.dart';

import '../../services/auth_service.dart';

class AuthMiddleware extends QMiddleware {
  @override
  Future<String?> redirectGuard(String path) async {
    if (authService.isAuth) {
      return null;
    }
    return '/login';
  }
}
