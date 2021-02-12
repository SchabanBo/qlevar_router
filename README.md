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

With Navigator2.0 Manage your project routes and create nested routes. Update only one widget in your page when navigating to new route. Simply navigation without context to your page.

There are cases when we need to change the route of the application without changing the entire page and without losing the state of the current page simply i want to update a part in it with a new route (common case is bottom navigation bar, sidebar in a dashboard, etc). That was so hard to accomplish in flutter unit now.
With this package you can do this [Nested Routing - Widget Update](#nested-routing---widget-update).
