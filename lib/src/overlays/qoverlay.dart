import 'package:flutter/cupertino.dart';

// ignore: one_member_abstracts
abstract class QOverlay {
  Future<T?> show<T>({NavigatorState? state, BuildContext? context});
}
