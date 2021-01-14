import '../../../qlevar_router.dart';
import '../../navigator/navigator.dart';

/// The match context tree for a route.
class MatchContext {
  final int key;
  final QRoute route;
  final String fullPath;
  final bool isComponent;
  final QNavigatorState state;
  bool isNew;
  MatchContext childContext;

  MatchContext(
      {this.key,
      this.fullPath,
      this.isComponent,
      QNavigatorState state,
      this.route,
      this.isNew = true,
      this.childContext})
      : state = state ?? QNavigatorState();

  MatchContext copyWith({String fullPath, bool isComponent}) => MatchContext(
      key: key,
      fullPath: fullPath ?? this.fullPath,
      isComponent: isComponent ?? this.isComponent,
      state: state,
      route: route,
      isNew: isNew,
      childContext: childContext);

  void treeUpdated() {
    isNew = false;
    if (childContext != null) {
      childContext.treeUpdated();
    }
  }

  @override
  String toString() => 'Key: $key, path: $fullPath, Name: ${route.name}';

  void printTree({int padding = 0}) {
    QR.log(
        // ignore: prefer_interpolation_to_compose_strings
        ''.padLeft(padding, '-') + '${toString()} With key ${state.hashCode}');
    if (childContext != null) {
      childContext.printTree(padding: ++padding);
    }
  }
}
