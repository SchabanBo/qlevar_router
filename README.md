# Qlevar Router (QR)

[![likes](https://badges.bar/qlevar_router/likes)](https://pub.dev/packages/qlevar_router)
[![popularity](https://badges.bar/qlevar_router/popularity)](https://pub.dev/packages/qlevar_router)
[![pub points](https://badges.bar/qlevar_router/pub%20points)](https://pub.dev/packages/qlevar_router)

```dart
// Define your routes
class AppRoutes{
  static String homePage ='Home Page';
  static String userPage ='User Page';
  final routes =<QRouteBase>[
    QRoute(name: homePage, path:'/', page:(c)=> HomePage()),
    QRoute(name: userPage, path:'/user/:userId', page:(c)=> UserPage()),
  ]
}

// Create your app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: QRouteInformationParser(),
      routerDelegate: QRouterDelegate(AppRoutes().routes()));
}


// from anywhere in your code navigate to new page with
QR.toName(AppRoutes.userPage, param:{'userId':2});
// or
QR.to('/user/2');
```

## Demo

[Show Demo](https://routerexample.qlevar.de)

## Learn more

[Wiki](https://github.com/SchabanBo/qlevar_router/wiki)

Qlevar router is flutter package to help you with managing your project routing, navigation, deep linking, route params, etc ...
With Navigator 2.0 Manage your project routes and create nested routes. Change only one widget on your page when navigating to the new route. Navigate without context from anywhere to anywhere.

See all [Features](https://github.com/SchabanBo/qlevar_router/wiki/02_Features)
