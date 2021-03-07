import 'package:flutter/widgets.dart';
import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';

class QRouter extends StatefulWidget {
  final navKey = GlobalKey<NavigatorState>();
  final QRouterController _controller;
  QNavigator get navigator => _controller;
  QRouter(this._controller);
  @override
  _QRouterState createState() => _QRouterState();
}

class _QRouterState extends State<QRouter> {
  @override
  void initState() {
    super.initState();
    widget._controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: widget.navKey,
        pages: widget._controller.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return QR.back();
        },
      );
}
