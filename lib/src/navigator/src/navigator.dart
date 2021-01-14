import 'package:flutter/widgets.dart';
import '../../types.dart';

class QNavigatorInternal extends QNavigator {
  final QNavigatorState _state;
  QNavigatorInternal(this._state);

  @override
  QNavigatorState createState() => _state;
}

typedef OnPop = bool Function();

class QNavigatorState extends State<QNavigatorInternal> {
  final _navigationKey = GlobalKey<NavigatorState>();
  final OnPop onPop;
  final List<Page<dynamic>> _stack;
  QNavigatorState({Page<dynamic> initPage, this.onPop}) : _stack = [initPage];

  void push(Page<dynamic> page) {
    _stack.add(page);
    _rebuild();
  }

  void replaceAll(List<Page<dynamic>> page) {
    _stack.clear();
    _stack.addAll(page);
    _rebuild();
  }

  void removeLast() {
    _stack.removeLast();
    _rebuild();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: _navigationKey,
        pages: _stack,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return onPop();
        },
      );
}
