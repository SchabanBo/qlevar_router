class QNaviagtionMode {
  final QNaviagtionModeType type;
  final String name;
  const QNaviagtionMode(this.type, this.name);

  factory QNaviagtionMode.asChild() =>
      const QNaviagtionMode(QNaviagtionModeType.Child, null);

  factory QNaviagtionMode.asChildof(String name) =>
      QNaviagtionMode(QNaviagtionModeType.ChildOf, name);

  factory QNaviagtionMode.asSibling() =>
      const QNaviagtionMode(QNaviagtionModeType.Sibling, null);

  factory QNaviagtionMode.asSiblingof(String name) =>
      QNaviagtionMode(QNaviagtionModeType.SiblingOf, name);

  factory QNaviagtionMode.onRoot() =>
      QNaviagtionMode(QNaviagtionModeType.Child, 'Root');
}

enum QNaviagtionModeType {
  Child,
  ChildOf,
  Sibling,
  SiblingOf,
}
