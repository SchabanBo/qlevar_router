import 'dart:io';

// ignore: avoid_classes_with_only_static_members
class QPlatform {
  static const bool isWeb = false;

  static final bool isIOS = Platform.isIOS || Platform.isMacOS;
}
