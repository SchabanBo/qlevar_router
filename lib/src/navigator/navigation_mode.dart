class QNaviagtionMode {
  final QNaviagtionModeType type;
  final String name;
  const QNaviagtionMode(this.type, this.name);

  factory QNaviagtionMode.asChild() =>
      const QNaviagtionMode(QNaviagtionModeType.Child, null);

  factory QNaviagtionMode.asChildof(String name) =>
      QNaviagtionMode(QNaviagtionModeType.ChildOf, name);

  factory QNaviagtionMode.asStackTo(String name) =>
      QNaviagtionMode(QNaviagtionModeType.StackTo, name);

  factory QNaviagtionMode.asRootChildren() =>
      QNaviagtionMode(QNaviagtionModeType.ChildOf, 'Root');

  factory QNaviagtionMode.asRootStack() =>
      QNaviagtionMode(QNaviagtionModeType.StackTo, 'Root');
}

enum QNaviagtionModeType {
  Child,
  ChildOf,
  StackTo,
}
