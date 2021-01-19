import 'package:flutter/widgets.dart';

import '../qr.dart';
import 'pages.dart';

class RouterController extends ChangeNotifier {
  final int key;
  final String name;
  final _pages = <QPage>[];
  List<QPage> get pages => List.unmodifiable(_pages);

  RouterController({this.key, this.name, QPage initPage}) {
    _pages.add(initPage);
    QR.log('${toString()} is created', isDebug: true);
  }

  void updateUrl() {
    if (key == -1) {
      notifyListeners();
    }
  }

  List<int> updatePage(QPage page, QNavigationMode mode) {
    QR.log('Update Page $name');
    final result = _updatePages(page, mode);
    QR.log('Update ${toString()} and remove $result', isDebug: true);
    notifyListeners();
    return result;
  }

  List<int> _updatePages(QPage page, QNavigationMode mode) {
    mode = mode ?? QNavigationMode();
    final cleanup = <int>[];
    switch (mode.type) {
      default:
        cleanup.addAll(_pages.map((e) => e.matchKey));
        _pages.clear();
        _pages.add(page);
    }
    return cleanup;
  }

  @override
  String toString() => 'Key: $key, name: $name [$hashCode]';
}
