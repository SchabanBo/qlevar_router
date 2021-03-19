import 'package:flutter/widgets.dart';

typedef PagesBuilder = List<QRouteBuilder> Function();

class QRouteBuilder {
  /// The [QRoute.name] for the defined route.
  /// The route must defined as a child for this current route
  final String? name;

  /// The widget to show for this route
  final Widget? widget;

  /// The path to set for this route
  /// leave `null` if you dont want to update the path
  final String? path;

  final Map<String, Object>? params;

  const QRouteBuilder.fromName(this.name, {this.params})
      : widget = null,
        path = null;

  const QRouteBuilder.custom(this.path, this.widget, {this.params})
      : name = null;
}
