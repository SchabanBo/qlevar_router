# How to use

## Installing

1- Add this to your package's pubspec.yaml file:

``` yaml
dependencies:
  qlevar_router:
```

2- Install it
You can install packages from the command line:

with Flutter:

``` cm
flutter pub get
```

3- Import it
Now in your Dart code, you can use:

```dart
import 'package:qlevar_router/qlevar_router.dart';
```

## Configuration

### define your routes

add new class that will contains the main routes of your app and define a list of type `List<QRouteBase>` and define your routes in it

```dart
class AppRoutes{
  static String homePage ='Home Page';
  static String userPage ='User Page';
  final routes =<QRouteBase>[
    QRoute(name: homePage, path:'/', page:(c)=> HomePage()),
    QRoute(name: userPage, path:'/user/:userId', page:(c)=> UserPage()),
  ]
}
```

then use the Router with the `MaterialApp` or `CupertinoApp`. and give the package router and parser to the app.

```dart
MaterialApp.router(
      routerDelegate: QR.router(AppRoutes().routes),
      routeInformationParser: QR.routeParser())
```
then from anywhere in your code navigate to new page with

```dart
QR.toName(AppRoutes.userPage, param:{'userId':2});
// or
QR.to('/user/2');
```
