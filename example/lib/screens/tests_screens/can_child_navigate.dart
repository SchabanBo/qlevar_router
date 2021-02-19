import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class TestCanChildNavigate extends StatefulWidget {
  final QRouteChild child;
  TestCanChildNavigate(this.child);
  @override
  _TestCanChildNavigateState createState() => _TestCanChildNavigateState();
}

class _TestCanChildNavigateState extends State<TestCanChildNavigate> {
  bool isAllowed = true;

  @override
  void initState() {
    super.initState();

    widget.child.canChildNavigation = () async {
      final can =
          await Future.delayed(Duration(milliseconds: 100), () => isAllowed);
      if (!can) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Child not allowed to navigate"),
        ));
      }
      return can;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                  value: isAllowed,
                  onChanged: (v) {
                    setState(() {
                      isAllowed = v;
                    });
                  }),
              Text('Is child allowed to navigate',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            ],
          ),
          ElevatedButton(
              onPressed: () => QR
                  .to('/home/test/can-child-navigate/${Random().nextInt(500)}'),
              child: Text('Update child')),
          SizedBox(width: 300, height: 300, child: widget.child.childRouter),
        ],
      ),
    );
  }
}

class TestCanChildNavigateChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(QR.params['id'].toString(),
            style: TextStyle(color: Colors.white, fontSize: 25)),
        ElevatedButton(onPressed: QR.back, child: Text('Back')),
      ],
    ));
  }
}
