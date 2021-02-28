import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class BottomNavigationBarExampleRoutes extends QRouteBuilder {
  static const bottomNavigationBar = 'BottomNavigationBar';
  static const bottomNavigationBarHome = 'BottomNavigationBarHome';
  static const bottomNavigationBarBusiness = 'BottomNavigationBarBusiness';
  static const bottomNavigationBarSchool = 'BottomNavigationBarSchool';

  @override
  QRoute createRoute() => QRoute(
          name: bottomNavigationBar,
          path: '/bottomNavigationBar',
          page: (c) => BottomNavigationBarExample(c),
          initRoute: '/home',
          children: [
            QRoute(
                name: bottomNavigationBarHome,
                path: 'home',
                page: (c) => Center(
                      child: Text(bottomNavigationBarHome,
                          style: TextStyle(fontSize: 25)),
                    )),
            QRoute(
                name: bottomNavigationBarBusiness,
                path: 'business',
                page: (c) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(bottomNavigationBarBusiness,
                              style: TextStyle(fontSize: 25)),
                          TextButton(
                              onPressed: () =>
                                  QR.toName(bottomNavigationBarSchool),
                              child: Text('Go to School',
                                  style: TextStyle(fontSize: 25))),
                        ],
                      ),
                    )),
            QRoute(
                name: bottomNavigationBarSchool,
                path: 'school',
                page: (c) => Center(
                      child: Text(bottomNavigationBarSchool,
                          style: TextStyle(fontSize: 25)),
                    )),
          ]);
}

class BottomNavigationBarExample extends StatefulWidget {
  final QRouteChild child;
  BottomNavigationBarExample(this.child);
  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  final childrenRoutes = [
    BottomNavigationBarExampleRoutes.bottomNavigationBarHome,
    BottomNavigationBarExampleRoutes.bottomNavigationBarBusiness,
    BottomNavigationBarExampleRoutes.bottomNavigationBarSchool,
  ];
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // set the init tab from the selected tab.
    _selectedIndex = childrenRoutes.indexOf(widget.child.currentChild.name);

    // update the selected tab when the child changed
    widget.child.onChildCall = () {
      setState(() {
        _selectedIndex = childrenRoutes.indexOf(widget.child.currentChild.name);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: widget.child.childRouter,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (i) => QR.toName(childrenRoutes[i]),
      ),
    );
  }
}
