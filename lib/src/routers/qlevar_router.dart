// import 'package:flutter/widgets.dart';

// import '../../qlevar_router.dart';
// import '../controllers/qrouter_controller.dart';
// import '../types/route_parser.dart';
// import 'router_delegate.dart';

// typedef AppBuilder = Widget Function(_RouterSettings);

// class QlevarRouter extends StatefulWidget {
//   final List<QRoute> routes;
//   final AppBuilder app;
//   QlevarRouter({required this.app, required this.routes});
//   @override
//   _QlevarRouterState createState() => _QlevarRouterState();
// }

// class _QlevarRouterState extends State<QlevarRouter> {
//   _RouterSettings? _settings;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addObserver(QR.urlController);
//     QR.treeInfo.namePath.addAll({QR.settings.rootRouterName: '/'});
//     final controller =
//         QR.createRouterController(QR.settings.rootRouterName, widget.routes);
//     _settings = _RouterSettings.fromController(controller);
//   }

//   @override
//   Widget build(BuildContext context) {
//     assert(_settings != null);
//     return widget.app(_settings!);
//   }
// }

// class _RouterSettings {
//   final QRouterDelegate delegate;
//   final QRouteInformationParser parser;
//   _RouterSettings(this.delegate, this.parser);
//   factory _RouterSettings.fromController(QRouterController controller) =>
//       _RouterSettings(QRouterDelegate(controller), QRouteInformationParser());
// }
