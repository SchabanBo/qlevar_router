import 'package:qlevar_router/qlevar_router.dart';

class DeferredLoader extends QMiddleware {
  final Future<dynamic> Function() loader;

  DeferredLoader(this.loader);
  @override
  Future onEnter() async {
    await loader();
  }
}
