import 'package:flutter/material.dart';

class QRoute {
  final String path;
  final Widget page;
  final QUri uri;
  QRoute({@required this.path, @required this.page}) : uri = QUri(path);
}

class QUri {
  final Uri uri;
  QUri(String path) : uri = Uri.parse(path);
}
