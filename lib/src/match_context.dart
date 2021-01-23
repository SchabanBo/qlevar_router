import 'qr.dart';
import 'types.dart';

/// The match context tree for a route.
class MatchContext {
  final int key;
  final QRoute route;
  final String fullPath;
  final bool isComponent;
  bool isNew;
  MatchContext childContext;

  MatchContext(
      {this.key,
      this.fullPath,
      this.isComponent,
      this.route,
      this.isNew = true,
      this.childContext,
      bool isCopy = false}) {
    // Run onInit for the new match.
    if (!isCopy && route?.onInit != null) {
      QR.log('Run onInit for ${route.name}', isDebug: true);
      route.onInit.call();
    }
  }

  MatchContext copyWith({String fullPath, bool isComponent, bool isNew}) =>
      MatchContext(
          key: key,
          fullPath: fullPath ?? this.fullPath,
          isComponent: isComponent ?? this.isComponent,
          route: route,
          isNew: isNew ?? this.isNew,
          childContext: childContext,
          isCopy: true);

  void treeUpdated() {
    isNew = false;
    if (childContext != null) {
      childContext.treeUpdated();
    }
  }

  void dispoase() {
    if (route?.onDispose != null) {
      QR.log('Run onDispose for ${route.name}', isDebug: true);
      route.onDispose.call();
    }
    if (childContext != null) {
      childContext.dispoase();
      childContext = null;
    }
  }

  @override
  String toString() => 'Key: $key, path: $fullPath, Name: ${route.name}';
}
