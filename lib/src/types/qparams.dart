import 'package:flutter/foundation.dart';

typedef ParamChanged = Function(Object?, Object?);

/// Class represent the param value
class ParamValue {
  final Object? _value;
  bool keepAlive;
  int? cleanupAfter;
  ParamChanged? onChange;
  Function()? onDelete;

  ParamValue(
    this._value, {
    this.keepAlive = false,
    this.cleanupAfter,
    this.onChange,
    this.onDelete,
  });

  /// Get the param as double
  double? get asDouble => hasValue ? double.tryParse(toString()) : null;

  /// Get the param as int
  int? get asInt => hasValue ? int.tryParse(toString()) : null;

  /// is param has value
  bool get hasValue => _value != null;

  /// Get the param value as String
  Object? get value => _value;

  ParamValue copyWith({
    Object? value,
    bool? keepAlive,
    int? cleanupAfter,
    ParamChanged? onChange,
    Function()? onDelete,
  }) {
    return ParamValue(
      value ?? _value,
      keepAlive: keepAlive ?? this.keepAlive,
      cleanupAfter: cleanupAfter ?? this.cleanupAfter,
      onChange: onChange ?? this.onChange,
      onDelete: onDelete ?? this.onDelete,
    );
  }

  bool isSame(ParamValue other) => _value == other.value;

  @override
  String toString() => hasValue ? value!.toString() : 'null';

  T? valueAs<T>() => value as T;
}

/// The params for the route
class QParams {
  final Map<String, ParamValue> _params;

  QParams({Map<String, ParamValue>? params})
      : _params = params ?? <String, ParamValue>{};

  /// get the params as map
  Map<String, ParamValue> get asMap => _params;

  Map<String, dynamic> get asValueMap {
    final result = <String, dynamic>{};
    for (var item in _params.entries) {
      result[item.key] = item.value.value;
    }
    return result;
  }

  /// Whether there is no params.
  bool get isEmpty => _params.isEmpty;

  /// Whether there is at least one param.
  bool get isNotEmpty => _params.isNotEmpty;

  /// get the params keys
  List<String> get keys => _params.keys.toList();

  /// params count
  int get length => _params.length;

  /// Get param from key
  ParamValue? operator [](String key) => _params[key];

  /// set new param
  void operator []=(String key, Object value) =>
      _params[key] = ParamValue(value);

  /// Add params
  void addAll(Map<String, dynamic> other) => _params
      .addAll(other.map((key, value) => MapEntry(key, ParamValue(value))));

  /// Add a param without showing it in the path, as default this param will
  /// be automatically deleted after one page navigation, to change this,
  /// change the [cleanUpAfter] value to keep it from more navigation times
  void addAsHidden(String key, Object value, {int cleanUpAfter = 1}) {
    _params[key] = ParamValue(
      value,
      cleanupAfter: cleanUpAfter,
      keepAlive: true,
    );
  }

  /// Get the params as Map
  Map<String, String> asStringMap() {
    final result = <String, String>{};
    for (var item in _params.entries) {
      result[item.key] = item.value.toString();
    }
    return result;
  }

  /// remove all params
  void clear() => _params.clear();

  QParams copyWith() => QParams(params: Map.from(_params));

  /// See if a parameter is Exist, if not create it with this `initValue`.
  /// if you set `keepAlive` to true then the package will not remove this param
  /// or you can set `cleanupAfter` so the package will clean up this param
  /// after X callas, where x is the number you set in `cleanupAfter`.
  /// to set a function to be called when this param is changed set `onChange`
  /// function it gives the current value and the new value and to set a function to be
  /// called when this param is deleted use `onDelete`
  void ensureExist(
    String name, {
    Object? initValue,
    int? cleanupAfter,
    bool keepAlive = false,
    ParamChanged? onChange,
    Function()? onDelete,
  }) {
    if (_params[name] != null) {
      return;
    }
    _params[name] = ParamValue(
      initValue,
      keepAlive: keepAlive || cleanupAfter != null,
      cleanupAfter: cleanupAfter,
      onChange: onChange,
      onDelete: onDelete,
    );
  }

  bool isSame(QParams other) =>
      length == other.length && mapEquals(asValueMap, other.asValueMap);

  void updateParam(
    String name,
    Object value, {
    int? cleanupAfter,
    bool keepAlive = false,
    ParamChanged? onChange,
    Function()? onDelete,
  }) {
    final newParam = _params[name]!.copyWith(
      value: value,
      cleanupAfter: cleanupAfter,
      keepAlive: keepAlive,
      onChange: onChange,
      onDelete: onDelete,
    );
    final params = Map<String, ParamValue>.from(_params);
    params[name] = newParam;
    updateParams(QParams(params: params));
  }

  /// add new params when path updates
  void updateParams(QParams newParams) {
    final newKeys = newParams.keys;
    for (var key in keys) {
      // is deleted
      if (!newKeys.contains(key)) {
        if (_params[key]?.onDelete != null) {
          _params[key]!.onDelete!();
        }
        if (!_params[key]!.keepAlive) {
          _params.remove(key);
        } else if (_params[key]!.cleanupAfter != null) {
          if (_params[key]!.cleanupAfter! <= 0) {
            _params.remove(key);
          } else {
            _params[key]!.cleanupAfter = _params[key]!.cleanupAfter! - 1;
          }
        }
      }
    }
    for (var key in newKeys) {
      if (keys.contains(key)) {
        if (!_params[key]!.isSame(newParams[key]!)) {
          if (_params[key]?.onChange != null) {
            _params[key]!.onChange!(
                _params[key]!._value, newParams[key]!._value);
          }
          _params[key] = _params[key]!.copyWith(value: newParams[key]!._value);
        }
      } else {
        _params[key] = newParams[key]!;
      }
    }
  }
}
