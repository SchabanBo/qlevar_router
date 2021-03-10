import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../helpers/widgets/history.dart';
import '../routes/qroute_internal.dart';
import 'qroute_key.dart';

class QHistory {
  final _history = <QHistoryEntry>[];
  bool allowDuplications = false;
  List<QHistoryEntry> get entries => List.unmodifiable(_history);

  QHistoryEntry get current => _history.last;

  QHistoryEntry get last => _history[_history.length - 2];

  bool get hasLast => _history.length > 1;

  bool get isEmpty => _history.isEmpty;

  int get length => _history.length;

  void removeLast({int count = 1}) {
    for (var i = 0; i < count; i++) {
      _history.removeLast();
    }
  }

  void removeWithNavigator(String navi) {
    _history.removeWhere((element) => element.navigator == navi);
  }

  void remove(QRouteInternal route) {
    final entry =
        _history.lastIndexWhere((element) => element.key.isSame((route.key)));
    _history.remove(entry);
  }

  void add(QHistoryEntry entry) {
    if (hasLast && !allowDuplications) {
      if (current.isSame(entry)) {
        removeLast();
      }
      if (last.isSame(entry)) {
        _history.removeAt(_history.length - 2);
      }
    }
    _history.add(entry);
  }

  void clear() => _history.clear();

  Widget debug() => DebugHistory(_history);
}

class QHistoryEntry {
  final QKey key;
  final String path;
  final String navigator;
  final bool isSkipped;
  final QParams params;
  QHistoryEntry(
      this.key, this.path, this.params, this.navigator, this.isSkipped);

  bool isSame(QHistoryEntry other) =>
      path == other.path && navigator == other.navigator;
}
