import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/date_time.dart';

class StoreScreen extends StatelessWidget {
  final QRouter childRouter;
  const StoreScreen(this.childRouter);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Store $now'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              QR.replace('/dashboard');
            },
            child: Text(
              'Dashboard',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: childRouter,
    );
  }
}
