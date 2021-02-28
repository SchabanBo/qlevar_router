import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/date_time.dart';
import '../../helpers/qbutton.dart';

class NavigationModeRoutes extends QRouteBuilder {
  static const navigationMode = "Navigation Mode";
  static const pageOne = "Page One";
  static const pageTwo = "Page Two";
  static const pageThree = "Page Three";
  static const childOne = "Child One";
  static const childTwo = "Child Two";
  static const childThree = "Child Three";

  @override
  QRoute createRoute() => QRoute(
          path: '/navigation-mode',
          name: navigationMode,
          page: (c) => NavigationModePage(c),
          children: [
            QRoute(
                path: '/page-one',
                name: pageOne,
                page: (c) => PageOne(c),
                initRoute: '/child-one',
                children: [
                  QRoute(
                      path: '/child-one',
                      name: childOne,
                      page: (c) => ChildOne())
                ]),
            QRoute(
                path: '/page-two',
                name: pageTwo,
                page: (c) => PageTwo(c),
                navigationMode: QNaviagtionMode.asRootChild(),
                children: [
                  QRoute(
                      path: '/child-two',
                      name: childTwo,
                      page: (c) => ChildTwo())
                ]),
            QRoute(
                path: '/page-three',
                name: pageThree,
                page: (c) => PageThree(c),
                children: [
                  QRoute(
                      path: '/child-three',
                      name: childThree,
                      page: (c) => ChildThree())
                ]),
          ]);
}

class NavigationModePage extends StatelessWidget {
  final QRouteChild child;
  NavigationModePage(this.child);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QButton('Rest to Navigation Mode Page',
                () => QR.toName(NavigationModeRoutes.navigationMode)),
            QButton('1- Go to (Page One) As Child (Defualt mode)',
                () => QR.toName(NavigationModeRoutes.pageOne)),
            QButton('''
2- Set (Page one) as root child
The Path will still as defined, but the page will be set as child for the root router.
This is a custom case, thats mean when this path is called from the browser url the case 1 will be used''',
                () {
              // first we need to rest to the navigation mode page,
              // so if this one page get cosed if it is already open.
              QR.toName(NavigationModeRoutes.navigationMode);
              QR.toName(NavigationModeRoutes.pageOne,
                  mode: QNaviagtionMode.asRootChild());
            }),
            QButton(
                '''
3- Call Page Two. the default mode for this route is as Root child,
So this page will behave as case 2 when it will be called from browser Url too''',
                () => QR.toName(NavigationModeRoutes.pageOne,
                    mode: QNaviagtionMode.asRootChild())),
          ],
        )),
        Expanded(child: child.childRouter)
      ],
    );
  }
}

class PageOne extends StatelessWidget {
  final QRouteChild child;
  PageOne(this.child);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: QR.getStackTreeWidget(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(now, style: TextStyle(fontSize: 20)),
          Text('PageOne', style: TextStyle(fontSize: 20)),
          Divider(),
          Expanded(child: child.childRouter)
        ],
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  final QRouteChild child;
  PageTwo(this.child);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(now, style: TextStyle(fontSize: 20)),
          Text('PageTwo', style: TextStyle(fontSize: 20)),
          Divider(),
          Expanded(child: child.childRouter)
        ],
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  final QRouteChild child;
  PageThree(this.child);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(now, style: TextStyle(fontSize: 20)),
          Text('PageThree', style: TextStyle(fontSize: 20)),
          Divider(),
          Expanded(child: child.childRouter)
        ],
      ),
    );
  }
}

class ChildOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(now, style: TextStyle(fontSize: 20)),
        Text('ChildOne', style: TextStyle(fontSize: 20)),
        QR.getStackTreeWidget(),
      ],
    );
  }
}

class ChildTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(now, style: TextStyle(fontSize: 20)),
        Text('ChildTwo', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

class ChildThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(now, style: TextStyle(fontSize: 20)),
        Text('ChildThree', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
