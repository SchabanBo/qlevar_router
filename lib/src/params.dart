/// The params for the route
class QParams {
  final Map<String, _ParamValue> _params;

  QParams({Map<String, _ParamValue> params})
      : _params = params ?? <String, _ParamValue>{};

  /// Get param from key
  _ParamValue operator [](String key) => _params[key];

  /// set new param
  void operator []=(String key, String value) =>
      _params[key] = _ParamValue(value);

  /// get the params as map
  Map<String, _ParamValue> get asMap => _params;
  Map<String, String> asStringMap() {
    final result = <String, String>{};
    for (var item in _params.entries) {
      result[item.key] = item.value._value;
    }
    return result;
  }

  /// params count
  int get length => _params.length;

  /// get the params keys
  List<String> get keys => _params.keys.toList();

  /// Add prarms
  void addAll(Map<String, _ParamValue> other) => _params.addAll(other);

  /// See if a parameter is Exist, if not create it
  void ensureExist(String name, {String initValue, bool keepAlive = false}) {
    final param = _params[name];
    if (param == null) {
      _params[name] = _ParamValue(initValue, keepAlive: keepAlive);
    }
  }

  /// add new params when path updates
  void updateParams(QParams newParams) {
    final newKeys = newParams.keys;
    for (var key in keys) {
      // is deleted
      if (!newKeys.contains(key)) {
        if (_params[key].onDelete != null) {
          _params[key].onDelete();
        }
        if (!_params[key].keepAlive) {
          _params.remove(key);
        }
      }
    }
    for (var key in newKeys) {
      if (keys.contains(key)) {
        if (!_params[key].isSame(newParams[key])) {
          if (_params[key].onChange != null) {
            _params[key].onChange(_params[key]._value, newParams[key]._value);
          }
          _params[key] = _params[key].copyWith(value: newParams[key]._value);
        }
      } else {
        _params[key] = newParams[key];
      }
    }
  }
}

/// Class represent the param value
class _ParamValue {
  final String _value;
  bool keepAlive;
  Function(String, String) onChange;
  Function() onDelete;

  _ParamValue(this._value,
      {this.keepAlive = false, this.onChange, this.onDelete});

  _ParamValue copyWith({
    String value,
    Function(String, String) onChange,
    Function() onDelete,
  }) {
    return _ParamValue(
      value ?? _value,
      onChange: onChange ?? this.onChange,
      onDelete: onDelete ?? this.onDelete,
    );
  }

  bool isSame(_ParamValue other) => _value == other.value;

  /// is param has value
  bool get hasValue => _value != null;

  /// Get the param value as String
  String get value => _value;

  /// Get the param as int
  int get asInt => int.parse(value);

  /// Get the param as double
  double get asDouble => double.parse(value);

  @override
  String toString() => value;
}
