import 'package:flutter/material.dart';

import '../routers/qrouter.dart';

abstract class RouterState<T extends StatefulWidget> extends State<T> {
  QRouter get router;

  @override
  void initState() {
    router.navigator.addListener(_update);
    super.initState();
  }

  void _update() {
    setState(() {});
  }

  @override
  void dispose() {
    router.navigator.removeListener(_update);
    super.dispose();
  }
}
