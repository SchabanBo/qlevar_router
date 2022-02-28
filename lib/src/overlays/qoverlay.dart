// ignore: one_member_abstracts
import 'package:flutter/material.dart';

mixin QOverlay {
  Future<T?> show<T>(
      {String? name, NavigatorState? state, BuildContext? context});
}
