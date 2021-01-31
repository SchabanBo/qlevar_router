import 'package:flutter/widgets.dart';

import '../qr.dart';
import 'navigation_mode.dart';
import 'pages.dart';

class RouterController extends ChangeNotifier {
  final int key;
  final String name;
  final _pages = <QPage>[];
  List<QPage> get pages => List.unmodifiable(_pages);

  bool get canPop => _pages.isNotEmpty;

  RouterController({this.key, this.name, QPage initPage}) {
    _pages.add(initPage);
    QR.log('${toString()} is created', isDebug: true);
  }

  void updateUrl() {
    if (key == -1) {
      notifyListeners();
    }
  }

  List<int> updatePage(QPage page, NavigationType type) {
    QR.log('Update Page $name');
    type ??= NavigationType.PopUntilOrPush;
    final result = _updatePages(page, type);
    QR.log('Update ${toString()} with type $type and remove $result',
        isDebug: true);
    notifyListeners();
    return result;
  }

  List<int> _updatePages(QPage page, NavigationType type) {
    final cleanup = <int>[];
    switch (type) {
      case NavigationType.ReplaceAll:
        cleanup.addAll(_pages.map((e) => e.matchKey));
        _pages.clear();
        _pages.add(page);
        break;
      case NavigationType.Pop:
        if (_pages.length <= 1) {
          throw Exception(
              'Can not pop page, stak contains only one page $toString()');
        }
        _pages.removeLast();
        break;
      case NavigationType.Push:
        _pages.add(page);
        break;
      case NavigationType.ReplaceLast:
        final last = _pages.last;
        cleanup.add(last.matchKey);
        _pages.remove(last);
        _pages.add(page);
        break;
      default: // NavigationType.PopUntilOrPush
        final index = _pages.indexWhere((element) => element.sameKey(page));
        if (index == -1) {
          _pages.add(page);
          break;
        }
        for (var i = index + 1; i < _pages.length; i++) {
          final pageToRemove = _pages[i];
          cleanup.add(pageToRemove.matchKey);
          _pages.remove(pageToRemove);
          i--;
        }
    }
    return cleanup;
  }

  @override
  String toString() => 'Key: $key, name: $name [$hashCode]';
}
