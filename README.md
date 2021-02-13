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
MaterialApp.router(
      routerDelegate: QR.router(AppRoutes().routes),
      routeInformationParser: QR.routeParser())

// from anywhere in your code navigate to new page with
QR.toName(AppRoutes.userPage, param:{'userId':2});
// or
QR.to('/user/2');
```

## Demo

[Show Demo](https://routerexample.qlevar.de)

## Learn more

[Wiki](https://github.com/SchabanBo/qlevar_router/wiki)

Qlevar router is flutter package to help you with managing your project routing, navigation, deep linking, route arguments etc ...
With Navigator2.0 Manage your project routes and create nested routes. Update only one widget in your page when navigating to new route. Simply navigation without context to your page.

The most cool feature for this package is [Nested Routing - Widget Update](0https://github.com/SchabanBo/qlevar_router/wiki/02_Features##nested-routing---widget-update) or see all [Features](https://github.com/SchabanBo/qlevar_router/wiki/02_Features)
