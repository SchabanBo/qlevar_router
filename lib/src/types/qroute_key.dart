import '../../qlevar_router.dart';

class QKey {
  int key;
  String name;
  QKey(this.name) : key = QR.treeInfo.routeIndexer++;

  bool hasName(String name) => this.name == name;
  bool hasKey(int key) => this.key == key;
  bool isSame(QKey other) => hasKey(other.key);

  @override
  String toString() => 'Key: [$key]($name)';
}
