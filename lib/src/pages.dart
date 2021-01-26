abstract class QRPage {
  final bool maintainState;
  final bool fullscreenDialog;
  final String restorationId;
  const QRPage(this.fullscreenDialog, this.maintainState, this.restorationId);
}

class QRMaterialPage extends QRPage {
  const QRMaterialPage(
      {bool fullscreenDialog = false,
      bool maintainState = true,
      String restorationId})
      : super(fullscreenDialog, maintainState, restorationId);
}

class QRCupertinoPage extends QRPage {
  final String title;
  const QRCupertinoPage(
      {bool fullscreenDialog = false,
      bool maintainState = true,
      this.title,
      String restorationId})
      : super(fullscreenDialog, maintainState, restorationId);
}

class QRPlatformPage extends QRPage {
  const QRPlatformPage(
      {bool fullscreenDialog = false,
      bool maintainState = true,
      String restorationId})
      : super(fullscreenDialog, maintainState, restorationId);
}
