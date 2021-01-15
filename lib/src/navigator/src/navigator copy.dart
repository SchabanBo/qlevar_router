import 'package:flutter/widgets.dart';

import '../../../qlevar_router.dart';
import '../../types.dart';
import 'navi_request.dart.dart';

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
  final NaviRequest _request;
  final List<Page<dynamic>> _stack;
  QNavigatorState(this._request, Page<dynamic> initPage, this.onPop)
      : _stack = [initPage];

  @override
  void initState() {
    super.initState();
    _request.addListener(_requestNofitier);
    QR.log('Request $_request has registerd');
  }

  void _requestNofitier() {
    if (_request.mode != RequestMode.UpdatePage) {
      return;
    }
    QR.log('Update for $_request', isDebug: true);
    switch (_request.naviMode.type) {
      default:
        replaceAll([_request.page]);
    }
  }

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
