# Qlevar Router (QR)

[![likes](https://badges.bar/qlevar_router/likes)](https://pub.dev/packages/qlevar_router)
[![popularity](https://badges.bar/qlevar_router/popularity)](https://pub.dev/packages/qlevar_router)
[![pub points](https://badges.bar/qlevar_router/pub%20points)](https://pub.dev/packages/qlevar_router)
[![codecov](https://codecov.io/gh/SchabanBo/qlevar_router/branch/master/graph/badge.svg?token=WF1RBRWTN1)](https://codecov.io/gh/SchabanBo/qlevar_router)

- [Qlevar Router (QR)](#qlevar-router-qr)
  - [Demo](#demo)
    - [The example Projects](#the-example-projects)
    - [The Samples Project](#the-samples-project)
  - [Params](#params)
    - [Route Component](#route-component)
    - [Query Param](#query-param)
    - [Params features](#params-features)
  - [Middleware](#middleware)
    - [redirectGuard](#redirectguard)
    - [canPop](#canpop)
    - [onMatch](#onmatch)
    - [onEnter](#onenter)
    - [onExit](#onexit)
  - [Not found page](#not-found-page)
  - [Page Transition](#page-transition)
  - [Add or remove routes in run Time](#add-or-remove-routes-in-run-time)
  - [Remove Url Hashtag](#remove-url-hashtag)

Qlevar router is flutter package to help you with managing your project routing, navigation, deep linking, route params, etc ...
With Navigator 2.0 Manage your project routes and create nested routes. Change only one widget on your page when navigating to the new route. Navigate without context from anywhere to anywhere.

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

you want to work with the basic functions from the navigator just set which navigator to use with `QR.activeNavigatorName` and then call it and use it

```dart
  QR.navigator.canPop;
  QR.navigator.currentRoute //Get the current route for this navigator

  QR.navigator.pushName(String name, {Map<String, dynamic>? params})
  QR.navigator.push(String path);

  QR.navigator.replaceAll(String path);
  QR.navigator.replaceAllWithName(String name, {Map<String, dynamic>? params});

  QR.navigator.replace(String path, String withPath);
  QR.navigator.removeLast();
```

or just call the navigator `QR.navigatorOf('Dashboard')`

Use this functions to see your navigators and Stack history and active pages in your project for better understanding on where you are in your project and how to order you pages.

```dart
QR.getActiveTree() // Will show you a dialog contains the tree of the active navigator and pages
QR.history.debug() // will show you a dialog contains the history stack for your current page.
```

## Demo

### The example Projects

[Show Demo](https://qlevar-router.netlify.app)

You can find the demo code in the [example](https://github.com/SchabanBo/qlevar_router/tree/master/example/lib) project

### The Samples Project

You can checkout the [samples project](https://github.com/SchabanBo/qr_samples) for more samples and to test some use case

## Params

send your params with the route, or set them before routing and call them from the next page. The params could be any object type.

### Route Component

```dart
QRoute(path: '/:orderId',page: (child) => OrderDetails()),

// and this receive it in your page
final orderId = QR.params['orderId'].toString()
```

### Query Param

```dart
 QR.to('/home/items/details?itemName=${e.name}&numbers=[2,6,7]')

// and this receive it in your page
final itemName = QR.params['itemName'].toString()
final numbers = QR.params['numbers']
```

### Params features

- **keepAlive**: by default the param will be deleted when navigating to new route that does not contains it, so if you don't what to deleted it in this case set this property to true and *the package will not deleted **as long as** this property is true*
- **onChange**: set function to be called when this param will be changed it give the current value and the new value
- **onDelete**: set function to be called when this param will be deleted
- **asInt**: Will return the value as int?
- **asDouble**: Will return the value as double
- **valueAs<T>**: Will return the value as the given type

## Middleware

with middleware you can set a custom actions to run with different event when you navigate
to define them add `QMiddlewareBuilder` or a custom class that extends 'QMiddleware' them in you route, they will be called in the same order they are defined in.

```dart
 QRoute(
    path: '/home',
    builder: () {
      return HomePage();
    },
    middleware: [
      QMiddlewareBuilder(
          onEnterFunc: () => print('-- Enter Parent page --'),
          onExitFunc: () => print('-- Exit Parent page --'),
          onMatchFunc: () => print('-- Parent page Matched --')),
      AuthMiddleware(),
    ])

class AuthMiddleware extends QMiddleware{
  final dataStorage = // Get you Data storage
  @override
  bool canPop() => dataStorage.canLeave;
  @override
  Future<String?> redirectGuard(String path) async => dataStorage.isLoggedIn ? null: '/parent/child-2';
}
```

### redirectGuard

you can redirect to new page whenever a page is called using the `redirectGuard`.

The `redirectGuard` give the path als parameter and takes the new path to redirect to.
or it takes `null` so the page can be accessed.

### canPop

can this route pop, called when trying to remove the page.

### onMatch

This method will be called *every time* a path match it.
  
### onEnter

This method will be called before adding the page to the stack and before the page building

### onExit

This method will be called before removing the page from the stack

## Not found page

you can set your custom not found page to show it whenever page was not found, or a default one will be set.

```dart
  QR.settings.notFoundPage = QRoute(path: '/404', builder: ()=> NotFoundPage())
```

## Page Transition

To chose the Transition for you page set the `QRoute.pageType` to the of the types:

- **QPlatformPage**: This type will be set as *QCupertinoPage* on IOS devises otherwise it will be *QMaterialPage*.
- **QMaterialPage**: It will use the default MaterialRouteTransition
- **QCupertinoPage**: It will use the default CupertinoRouteTransition
- **QCustomPage**: to define a custom transition for your page.
- **QSlidePage**: a predefined slide transition

## Add or remove routes in run Time

You can add new routes or delete existing route from the route tree dynamically while the app is running.
Just chose which navigator you want to add the routes to and then call

```dart
final navigator = QR.rootNavigator; // to add routes to the root navigator
final navigator = QR.navigatorOf('/dashboard') // or add the routes to the dashboard navigator
navigator.addRoutes([QRoute(path: '/payrolls', builder:()=> PayrollsPage()]);
// now the use can navigate to the payrolls page
navigator.removeRoutes(['/payrolls']);
// now if the use navigate to the payrolls page he will get not found page
```

## Remove Url Hashtag

If you what to remove the hashtag from the url place in you main method

```dart
void main() {
  QR.setUrlStrategy();
  runApp(MyApp());
}
```

*Note:* sometimes in release mode you could get error when you remove the hashtag, to fix it please see [this](https://github.com/SchabanBo/qlevar_router/issues/10)
