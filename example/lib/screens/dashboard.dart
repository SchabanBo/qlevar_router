import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/date_time.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text('Dashboard $now'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              QR.replace('/store');
            },
            child: Text(
              'Store',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
