import 'package:flutter/widgets.dart';

import '../qr.dart';
import '../types.dart';
import 'navigation_type.dart';
import 'page_types.dart';

class RouterController extends ChangeNotifier {
  final int key;
  final String name;
  final navKey = GlobalKey<NavigatorState>();
  final _pages = <QPage>[];
  // This pages are the pages to return when the key is -1.
  // Fix JustUrl problem with root router.
  final _pagesCopy = <QPage>[];

  QRouteChild routeChild;

  List<QPage> get pages =>
      List.unmodifiable(_pagesCopy.isNotEmpty ? _pagesCopy : _pages);

  bool get canPop => _pages.length > 1;

  RouterController({this.key, this.name, this.routeChild, QPage initPage}) {
    _pages.add(initPage);
    QR.log('${toString()} is created', isDebug: true);
  }

  void updateUrl() {
    if (key == -1) {
      if (_pagesCopy.isEmpty) _pagesCopy.addAll(_pages);
      notifyListeners();
    }
  }

  PopResult pop() {
    if (!canPop) {
      QR.log('Page cant pop, no another page in the stack');
      return PopResult(false);
    }
    final cleanup = _pages.last.matchKey;
    _pages.removeLast();
    notifyListeners();
    return PopResult(true, cleanup: cleanup);
  }

  List<int> updatePage(QPage page, NavigationType type, bool justUrl) {
    QR.log('Update ${justUrl ? 'Url' : 'Page'} $name');
    final result = _updatePages(page, type);
    QR.log('Update ${toString()} with type $type and remove $result',
        isDebug: true);
    if (!justUrl) {
      if (key == -1) _pagesCopy.clear();
      notifyListeners();
    }
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
        final index =
            _pages.indexWhere((element) => element.sameMatchKey(page.matchKey));
        if (index == -1) {
          // Page not exist add it.
          _pages.add(page);
          break;
        }
        if (index == _pages.length - 1) {
          // Page is on top replace it.
          _pages.removeAt(index);
          _pages.add(page);
          break;
        }
        // page exist remove unit it
        for (var i = index + 1; i < _pages.length; i++) {
          final pageToRemove = _pages[i];
          cleanup.add(pageToRemove.matchKey);
          _pages.remove(pageToRemove);
          i--;
        }
    }
    return cleanup;
  }

  void setChildOnTop(int matchKey) {
    final page = _pages.firstWhere((element) => element.sameMatchKey(matchKey),
        orElse: () => null);
    if (page == null || _pages.last == page) {
      return;
    }
    _pages.remove(page);
    _pages.add(page);
    notifyListeners();
  }

  void childCalled(QRoute child) {
    routeChild.currentChild = child;
    if (routeChild.onChildCall != null) {
      routeChild.onChildCall();
    }
  }

  @override
  String toString() => 'Key: $key, name: $name';
}

class PopResult {
  final bool didPop;
  final int cleanup;
  PopResult(this.didPop, {this.cleanup});
}
