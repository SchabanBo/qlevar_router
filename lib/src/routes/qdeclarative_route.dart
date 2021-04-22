import 'package:flutter/cupertino.dart';

import '../../qlevar_router.dart';

/// Define declarative route
/// used with `QDeclarative`
class QDRoute {
  /// The name of this route
  final String name;

  /// The default widget builder for this route
  final PageBuilder builder;

  /// Set the page type for this route
  /// you can use [QMaterialPage], [QCupertinoPage] or [QPlatformPage]
  /// The default is [QPlatformPage]
  final QPage? pageType;

  /// The condition to show this page
  final bool Function() when;

  /// what should happen when user try to pop the page
  final VoidCallback? onPop;

  const QDRoute({
    required this.name,
    required this.builder,
    required this.when,
    this.onPop,
    this.pageType,
  });
}
