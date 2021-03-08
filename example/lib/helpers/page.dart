import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class PageContainer extends StatelessWidget {
  final Widget body;
  PageContainer(this.body);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qlevar Router'),
        centerTitle: true,
        actions: [
          QR.getActiveTree(),
          const SizedBox(width: 15),
          QR.history.debug(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.fill)),
        child: body,
      ),
    );
  }
}
