import 'package:flutter/widgets.dart';
import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';

class QRouter extends StatelessWidget {
  final navKey = GlobalKey<NavigatorState>();
  final QRouterController controller;

  QRouter(this.controller);
  @override
  Widget build(BuildContext context) => Navigator(
        key: navKey,
        pages: controller.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return QR.back();
        },
      );
}
