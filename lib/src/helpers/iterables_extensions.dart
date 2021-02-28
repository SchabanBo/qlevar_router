extension Iterables<T> on Iterable<T> {
  /// Group list by a custom key
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) => fold(
      <K, List<T>>{},
      (map, element) =>
          map..putIfAbsent(keyFunction(element), () => <T>[]).add(element));

  bool get notNullOrEmpty => this != null && isNotEmpty;
}
