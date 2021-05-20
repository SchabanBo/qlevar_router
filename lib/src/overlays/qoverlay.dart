import 'package:flutter/cupertino.dart';

// ignore: one_member_abstracts
mixin QOverlay {
  Future<T?> show<T>(
      {String? name, NavigatorState? state, BuildContext? context});
}
