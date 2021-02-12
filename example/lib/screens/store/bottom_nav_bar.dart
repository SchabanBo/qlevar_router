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
                      child: Text(bottomNavigationBarBusiness,
                          style: TextStyle(fontSize: 25)),
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
  final QRouter childRouter;
  BottomNavigationBarExample(this.childRouter);
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
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: widget.childRouter,
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
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      // To update the selected tab.
      _selectedIndex = index;
    });
    // To update the page
    QR.toName(childrenRoutes[index]);
  }
}
