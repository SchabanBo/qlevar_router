import 'package:flutter/cupertino.dart';
import '../../qr.dart';

class NaviRequest extends ChangeNotifier {
  int key;
  String name;
  Page<dynamic> page;
  QNavigationMode naviMode;
  RequestMode mode;

  NaviRequest({
    this.key,
    this.name,
    this.page,
    this.naviMode,
    this.mode = RequestMode.None,
  }) {
    QR.log('${toString()} is created', isDebug: true);
  }

  void updatePage(Page<dynamic> _page, QNavigationMode _mode) {
    page = _page;
    naviMode = _mode ?? QNavigationMode();
    mode = RequestMode.UpdatePage;
    QR.log('${toString()} hasListeners: $hasListeners', isDebug: true);
    notifyListeners();
  }

  void updateUrl() {
    mode = RequestMode.UpdateUrl;
    notifyListeners();
  }

  @override
  void dispose() {
    print('${toString()} dispose');
    super.dispose();
  }

  @override
  String toString() => 'Key: $key, name: $name [$hashCode]';
}

enum RequestMode {
  None,
  UpdateUrl,
  UpdatePage,
}
