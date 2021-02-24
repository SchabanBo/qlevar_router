import '../../qlevar_router.dart';

class NavigatioRequest {
  String path;
  String name;
  NavigationType type;
  bool justUrl;
  QNaviagtionMode mode;
  NavigatioRequest(this.path, this.name, this.justUrl, this.mode, this.type);
}
