import '../../qlevar_router.dart';

class QHistoryEntry {
  final String path;
  final String navigator;
  final QParams params;
  QHistoryEntry(this.path, this.params, this.navigator);
}
