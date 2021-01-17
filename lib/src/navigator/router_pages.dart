import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../routes_tree/routes_tree.dart';
import '../types.dart';

abstract class QRPage extends Page<dynamic> {
  final MatchContext match;
  final QRouter childRouter;
  final bool fullscreenDialog;
  final bool maintainState;

  const QRPage({
    @required this.match,
    this.childRouter,
    this.maintainState = true,
    this.fullscreenDialog = false,
    LocalKey key,
    String name,
    Object arguments,
  })  : assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(key: key, name: name, arguments: arguments);

  @override
  bool canUpdate(Page other) {
    return other.runtimeType == runtimeType &&
        (other as QRPage).match.key == match.key;
  }
}

class QRMaterialPage extends QRPage {
  const QRMaterialPage({
    @required MatchContext match,
    @required QRouter childRouter,
    bool fullscreenDialog = false,
    bool maintainState = true,
    LocalKey key,
    String name,
    Object arguments,
  }) : super(
          match: match,
          childRouter: childRouter,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          key: key,
          name: name,
          arguments: arguments,
        );

  factory QRMaterialPage.fromMath(
    MatchContext match,
    QRouter childRouter,
  ) =>
      QRMaterialPage(
          childRouter: childRouter,
          match: match,
          key: ValueKey(match.key),
          name: match.route.name);

  @override
  Route createRoute(BuildContext context) {
    return _PageBasedMaterialPageRoute(page: this);
  }
}

class _PageBasedMaterialPageRoute extends PageRoute<dynamic>
    with MaterialRouteTransitionMixin {
  _PageBasedMaterialPageRoute({
    @required QRPage page,
  })  : assert(page != null),
        super(settings: page);

  QRPage get _page => settings as QRPage;

  @override
  Widget buildContent(BuildContext context) {
    final match = _page.match;
    if (match.route.onInit != null) {
      match.route.onInit.call();
    }
    return match.route.page(_page.childRouter);
  }

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  void dispose() {
    final match = _page.match;
    if (match.route.onDispose != null) {
      match.route.onDispose.call();
    }
    super.dispose();
  }
}
