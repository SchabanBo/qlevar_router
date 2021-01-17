import 'package:flutter/widgets.dart';

import '../qr.dart';

class RouterController extends ChangeNotifier {
  final int key;
  final String name;
  final _pages = <Page<dynamic>>[];
  List<Page<dynamic>> get pages => List.unmodifiable(_pages);

  RouterController({this.key, this.name, Page<dynamic> initPage}) {
    _pages.add(initPage);
    QR.log('${toString()} is created', isDebug: true);
  }

  void updateUrl() {
    if (key == -1) {
      notifyListeners();
    }
  }

  void updatePage(Page<dynamic> page, QNavigationMode mode) {
    QR.log('Update ${toString()}', isDebug: true);
    _updatePages(page, mode);
    notifyListeners();
  }

  bool onPop() {}

  void _updatePages(Page<dynamic> page, QNavigationMode mode) {
    mode = mode ?? QNavigationMode();
    switch (mode.type) {
      default:
        _pages.clear();
        _pages.add(page);
    }
  }

  @override
  String toString() => 'Key: $key, name: $name [$hashCode]';
}
