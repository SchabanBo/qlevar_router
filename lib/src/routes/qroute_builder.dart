import 'package:flutter/widgets.dart';

class QRouteBuilder {
  /// The [QRoute.name] for the defined route.
  /// The route must defined as a child for this current route
  final String? name;

  /// The widget to show for this route
  final Widget? widget;

  /// The path to set for this route
  /// leave `null` if you dont want to update the path
  final String? path;

  const QRouteBuilder.fromName(this.name)
      : widget = null,
        path = null;

  const QRouteBuilder.custom(this.path, this.widget) : name = null;
}
