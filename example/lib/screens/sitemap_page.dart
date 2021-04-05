import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class SiteMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: QR.navigator.getRoutesWidget,
    );
  }
}
