import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../helpers/widgets/history.dart';

class QHistory {
  final _history = <QHistoryEntry>[];
  bool allowDuplications = false;
  List<QHistoryEntry> get entries => List.unmodifiable(_history);

  QHistoryEntry get current => _history.last;

  QHistoryEntry get last => _history[_history.length - 2];

  bool get hasLast => _history.length > 1;

  void removeLast({int count = 1}) {
    for (var i = 0; i < count; i++) {
      _history.removeLast();
    }
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

  Widget debug() => DebugHistory(_history);
}

class QHistoryEntry {
  final String path;
  final String navigator;
  final bool isSkipped;
  final QParams params;
  QHistoryEntry(this.path, this.params, this.navigator, this.isSkipped);

  bool isSame(QHistoryEntry other) =>
      path == other.path && navigator == other.navigator;
}
