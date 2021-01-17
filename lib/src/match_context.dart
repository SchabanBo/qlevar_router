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
      this.childContext});

  MatchContext copyWith({String fullPath, bool isComponent, bool isNew}) =>
      MatchContext(
          key: key,
          fullPath: fullPath ?? this.fullPath,
          isComponent: isComponent ?? this.isComponent,
          route: route,
          isNew: isNew ?? this.isNew,
          childContext: childContext);

  void treeUpdated() {
    isNew = false;
    if (childContext != null) {
      childContext.treeUpdated();
    }
  }

  @override
  String toString() => 'Key: $key, path: $fullPath, Name: ${route.name}';
}
