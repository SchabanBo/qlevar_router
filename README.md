# Qlevar Router (QR)

[![likes](https://badges.bar/qlevar_router/likes)](https://pub.dev/packages/qlevar_router)
[![popularity](https://badges.bar/qlevar_router/popularity)](https://pub.dev/packages/qlevar_router)
[![pub points](https://badges.bar/qlevar_router/pub%20points)](https://pub.dev/packages/qlevar_router)

```dart
// Define your routes
class AppRoutes {
  static String homePage = 'Home Page';
  static String userPage = 'User Page';
  final routes = [
    QRoute(name: homePage, path: '/', builder: () => HomePage()),   
    QRoute(
        name: userPage,
        path: '/user/:userId',
        builder: () => HomePage(),
        children: [
          QRoute(name: homePage, path: '/settings', builder: () => SettingsPage()),
          QRoute(name: homePage, path: '/profile', builder: () => ProfilePage()),
        ]),
    QRoute(path: '/products/:category(\w)', builder: () => ProductCategory()),
    QRoute(path: '/products/:id((^[0-9]\$))', builder: () => ProductDetails()),
    QRoute.withChild(
        path: '/nested',
        builderChild: (r) => NestedRoutePage(r),
        initRoute: '/child',
        children: [
          QRoute(path: '/child', builder: () => NestedChild('child')),
          QRoute(
              path: '/child-1',
              builder: () => NestedChild('child 1'),
              pageType: QSlidePage()), // Will add slide animation to the page transaction
        ]),
  ];
}

// Create your app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: QRouteInformationParser(),
      routerDelegate: QRouterDelegate(AppRoutes().routes));
}

// from anywhere in your code navigate to new page with
QR.toName(AppRoutes.userPage, param:{'userId':2});
// or
QR.to('/user/2');

QR.to('/user/6/profile')  // Here the Stack will be HomePage -> ProfilePage()
QR.to('products/456')     // Will call ProductDetails page
QR.to('products/garden')  // Will call ProductCategory page
QR.back()                 // Go back to the last page(in this case 'products/456')
QR.currentPath            // will show the current path 
```

Got lost with the many levels and nested navigator in your project
as debug widgets i have added

```dart
QR.getActiveTree() // Will show you a dialog contains the tree of the active navigator and pages
QR.history.debug() // will show the history stack for your current page.
```

## Demo

[Show Demo](https://routerexample.qlevar.de)

## Learn more

[Wiki](https://github.com/SchabanBo/qlevar_router/wiki)

Qlevar router is flutter package to help you with managing your project routing, navigation, deep linking, route params, etc ...
With Navigator 2.0 Manage your project routes and create nested routes. Change only one widget on your page when navigating to the new route. Navigate without context from anywhere to anywhere.

See all [Features](https://github.com/SchabanBo/qlevar_router/wiki/02_Features)
