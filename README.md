# Qlevar Router (QR)

[![likes](https://img.shields.io/pub/likes/qlevar_router?logo=dart)](https://pub.dev/packages/qlevar_router)
[![popularity](https://img.shields.io/pub/popularity/qlevar_router?logo=dart)](https://pub.dev/packages/qlevar_router)
[![pub points](https://img.shields.io/pub/points/qlevar_router?logo=dart)](https://pub.dev/packages/qlevar_router) 
[![codecov](https://codecov.io/gh/SchabanBo/qlevar_router/branch/master/graph/badge.svg?token=WF1RBRWTN1)](https://codecov.io/gh/SchabanBo/qlevar_router)
[![HitCount](https://hits.dwyl.com/SchabanBo/qlevar_router.svg?style=flat-square)](https://pub.dev/packages/qlevar_router)


- [Qlevar Router (QR)](#qlevar-router-qr)
  - [Demo](#demo)
    - [The example Projects](#the-example-projects)
    - [The Samples Project](#the-samples-project)
  - [Parameters](#parameters)
    - [Path Parameters](#path-parameters)
    - [Query Parameters](#query-parameters)
    - [Hidden params](#hidden-params)
    - [Params features](#params-features)
  - [Middleware](#middleware)
    - [global middleware](#global-middleware)
  - [Priority](#priority)
    - [redirectGuard](#redirectguard)
    - [canPop](#canpop)
    - [onMatch](#onmatch)
    - [onEnter](#onenter)
    - [onExit](#onexit)
    - [OnExited](#onexited)
  - [Nested navigators](#nested-navigators)
    - [Saving pages state when navigating](#saving-pages-state-when-navigating)
    - [PageAlreadyExistAction](#pagealreadyexistaction)
  - [Observer](#observer)
  - [Not found page](#not-found-page)
  - [Deferred loading](#deferred-loading)
  - [Page Transition](#page-transition)
    - [Mix it up](#mix-it-up)
    - [App Page Transition](#app-page-transition)
  - [waiting for page result](#waiting-for-page-result)
  - [Restoration management](#restoration-management)
  - [Other features](#other-features)
  - [Add or remove routes in run Time](#add-or-remove-routes-in-run-time)
  - [Clean Structure](#clean-structure)
  - [Testing](#testing)
  - [Declarative routing](#declarative-routing)
    - [QDRoute](#qdroute)
    - [How Declarative router works](#how-declarative-router-works)
  - [Remove Url Hashtag](#remove-url-hashtag)
  - [Web hot reload](#web-hot-reload)
  - [Articles](#articles)
  - [Projects](#projects)
  - [Well tested](#well-tested)
  - [Contribute](#contribute)

Qlevar router is a flutter package to help you with managing your project routing, navigation, deep linking, route params, etc ...
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
QR.toName(AppRoutes.userPage, params:{'userId':2});
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

or just call the navigator `QR.navigatorOf('Dashboard')`.
**Note:** The routes name must be unique for each route in the app.

Use these functions to see your navigators and Stack history and active pages in your project for a better understanding of where you are in your project and how to order your pages.

```dart
QR.getActiveTree() // Will show you a dialog contains the tree of the active navigator and pages
QR.history.debug() // will show you a dialog contains the history stack for your current page.
```

## Demo

### The example Projects

Please check out the demo of Qlevar Router [here] (https://qlevar-router.netlify.app) to see how it works. You can find the code for this in [here](https://github.com/SchabanBo/qlevar_router/tree/master/example/lib)

The demo includes the following pages:

- [Store](https://qlevar-router.netlify.app/#/store): A simple page navigation example with passing parameters through the URL.
- [Dashboard](https://qlevar-router.netlify.app/#/dashboard): An example of authentication middleware and nested routes with sidebar.
- [MobileStore](https://qlevar-router.netlify.app/#/mobile/stores):  An example of a bottom navigation bar.
- [Middleware](https://qlevar-router.netlify.app/#/parent):  An example of different methods for the [middleware.](#middleware).
- [Declarative](https://qlevar-router.netlify.app/#/declarative): An example of navigating based on the state of an object.
- [EditableRoutes](https://qlevar-router.netlify.app/#/editable-routes/child): An example of adding or removing routes from the routes tree during runtime.

### The Samples Project

In addition to the demo, you can find more samples and test some use cases in the [samples project](https://github.com/SchabanBo/qr_samples) Here are a few examples:

- [Dashboard with splash page Example](https://github.com/SchabanBo/qr_samples/blob/main/lib/common_cases/dashboard.dart)
- [Bottom Navigation bar Example](https://github.com/SchabanBo/qr_samples/blob/main/lib/common_cases/bottom_nav_bar.dart)
- [TabView Example](https://github.com/SchabanBo/qr_samples/blob/main/lib/common_cases/tab_view.dart)
- [NavRail Example](https://github.com/SchabanBo/qr_samples/blob/main/lib/common_cases/nav_rail.dart)

## Parameters

send your params with the route. The params could be any object type.

### Path Parameters

```dart
QRoute(path: '/:orderId',page: (child) => OrderDetails()),

// User regex to define what this parameter can be
// like this parameters can only be numbers
QRoute(path: '/:id(^[0-9]+\$)', builder: () => Text('Case 2')), 

// and this receive it in your page
final orderId = QR.params['orderId'].toString()
```

### Query Parameters

```dart
 QR.to('/home/items/details?itemName=${e.name}&numbers=[2,6,7]')

// and this receive it in your page
final itemName = QR.params['itemName'].toString()
final numbers = QR.params['numbers']
```

### Hidden params

if you want to pass data between the page without showing it in the URL, you can use `QR.params.addAsHidden` this will add values to use after one page navigation, in the next time you navigate to a new page the param will be cleaned up. to keep it for more time, set the cleanUpAfter parameter.

**NOTE:** using this on web will cause the data to be lost if the user refreshes the page.

```dart
QR.params.addAsHidden('param3', true, cleanUpAfter: 2);
```

### Params features

- **keepAlive**: by default, the param will be deleted when navigating to a new route that does not contain it, so if you don't what to delete it in this case set this property to true, and *the package will not delete **as long as** this property is true*
- **onChange**: set function to be called when this param will be changed it gives the current value and the new value
- **onDelete**: set function to be called when this param will be deleted
- **asInt**: Will return the value as int?
- **asDouble**: Will return the value as double
- **valueAs<T>**: Will return the value as the given type
- **cleanupAfter**: set `cleanupAfter` so the package will clean up this param after X callas, where x is the number you set in `cleanupAfter`, a call could be push, replace, pop or to

## Middleware

with middleware, you can set custom actions to run with the different event when you navigate
to define them add `QMiddlewareBuilder` or a custom class that extends 'QMiddleware' them in your route, they will be called in the same order they are defined in.

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

![Middleware](./example/assets/middleware.png)

### global middleware

you can add global middleware to run on *every* route, to do that add the middlewares to `QR.settings.globalMiddleware`

```dart
QR.settings.globalMiddleware = [
  QMiddlewareBuilder(
      onEnterFunc: () => print('-- Enter Parent page --'),
      onExitFunc: () => print('-- Exit Parent page --'),
      onMatchFunc: () => print('-- Parent page Matched --')),
  AuthMiddleware(),
];
```

## Priority

The priority of the middleware, the lower the number the higher the priority. Middleware with the same priority will be executed in the order they were added
Middleware with higher priority will be executed first. The default priority is 500.

```dart
QRoute(
    path: '/home',
    builder: () => HomePage(),
    middleware: [
      QMiddlewareBuilder(
          priority: 1,
          onEnterFunc: () async => print('-- Enter Parent page --'),
          onExitFunc: () async => print('-- Exit Parent page --'),
          onMatchFunc: () async => print('-- Parent page Matched --')),
      QMiddlewareBuilder(
          priority: 2,
          onEnterFunc: () async => print('-- Enter Parent page --'),
          onExitFunc: () async => print('-- Exit Parent page --'),
          onMatchFunc: () async => print('-- Parent page Matched --')),
    ])
```

### redirectGuard

you can redirect to a new page whenever a page is called using the `redirectGuard`.

The `redirectGuard` gives the path as a parameter and takes the new path to redirect to.
or it takes `null` so the page can be accessed.

### canPop

can this route pop, called when trying to remove the page.

### onMatch

This method will be called *every time* a path match it.
  
### onEnter

This method will be called before adding the page to the stack and before the page building

### onExit

This method will be called before removing the page from the stack

### OnExited

This method will be called one frame after the page was removed from the stack, this will be the best place to cleanup any resource that the page was using.

## Nested navigators

you can nest navigators inside each other, to do that you need to add `QRoute.withChild` to your routes tree.

```dart
QRoute.withChild(
  name: store,
  path: '/store',
  builderChild: (router) => StorePage(router),
  initRoute: '/orders',
  children: [
    QRoute(name: items, path: '/items', builder: () => ItemsPage()),
    QRoute(name: orders, path: '/orders', builder: () => OrderPage()),
  ],
);
```

the `builderChild` will be called with the child navigator as a parameter, which is just a widget you can place on any place on the screen where you want to show the children of this route.
see the example for more details. 
[routes definition](https://github.com/SchabanBo/qlevar_router/blob/master/example/lib/routes/dashboard_routes.dart)
[widget definition](https://github.com/SchabanBo/qlevar_router/tree/master/example/lib/pages/dashboard)

### Saving pages state when navigating

if you want to save the state of the pages when navigating between them, you have tow options:

1- when navigating between the pages, set `pageAlreadyExistAction` to 'bringToTop', this will bring the page to the top of the stack. if this page has any child pages, they will be reordered to be on top of the stack the same way as they were before.
2- you can use 'QR.navigatorOf(DashboardRoutes.dashboard).switchTo('home');' to switch between the pages, this will keep the state of the pages. This will internally set `pageAlreadyExistAction` to 'bringToTop'.

### PageAlreadyExistAction

This parameter will be used when you navigate to a page that already exists in the stack.

- **bringToTop**: will bring the page to the top of the stack, if the page has any child pages, they will be reordered to be on top of the stack the same way as they were before. see #61
*NOTE:* this will not work for the route with `/` path
- **IgnoreChildrenAndBringToTop**: will bring just the page to the top of the stack, if the page has any child pages, they will be ignored.
- **remove**: if the page already exists, this will remove all pages on the top  until the page is on the top of the stack. 

## Observer

To set your observers to the navigators for the root navigator you need to pass them to `QRouterDelegate`

```dart
RouterDelegate(
  appRoutes.routes,
  observers: [
    // Your observers
  ],
),
```

for nested navigators you can pass them when defining a nested route

```dart
QRoute.withChild(
  path: '/editable-routes',
  builderChild: (child) => AddRemoveRoutes(child),
  observers: [
    // Add your observer for this navigator
  ],
  children: [..],
);
```

to set global observes for every navigation in your app you could set QObserver to the `QR.observer`.
QObserver can have :

- **onNavigate**: add listener to every new route that will be added to the tree
- **onPop**: Add listener to every route that will be deleted from the tree

## Not found page

you can set your custom not found page to show it whenever a page was not found, or a default one will be set.

```dart
  QR.settings.notFoundPage = QRoute(path: '/404', builder: ()=> NotFoundPage())
```

##  Deferred loading
For web application you can split your compiled java script files to moe than one for helping with the page loading speed. read more about it [here](https://medium.com/@SchabanBo/reduce-your-flutter-web-app-loading-time-8018d8f442)

## Page Transition

To chose the Transition for your page set the `QRoute.pageType` to the of the types:

- **QPlatformPage**: This type will be set as *QCupertinoPage* on IOS devices otherwise it will be *QMaterialPage*.
- **QMaterialPage**: It will use the default MaterialRouteTransition
- **QCupertinoPage**: It will use the default CupertinoRouteTransition
- **QCustomPage**: to define a custom transition for your page.
- **QSlidePage**: a predefined slide transition
- **QFadePage**: a predefined fade transition

### Mix it up

you can mix the transition animation by setting the property `withType`
so if you want to show slide and fade transition you can do

```dart
QRoute(
      path: '/child',
      pageType: QFadePage(
          transitionDurationMilliseconds: 1000,
          withType: QSlidePage(transitionDurationMilliseconds: 5000), // set the type to mix with
          ),
      builder: () => TextPage('Hi child 4')),
]),
```

please note that when you mix transitions the only the first transition duration will be used
in this case `QFadePage.transitionDurationMilliseconds (1000)` will be used and `QSlidePage.transitionDurationMilliseconds (5000)` will be ignored

**QPlatformPage**, **QMaterialPage** and **QCupertinoPage** CANNOT be mixed.

### App Page Transition

you can define the Transition for all pages in the app with setting the page type in `QR.settings.pagesType`

## waiting for page result

If you need to wait for a result from another page, you can do so by setting `waitForResult` to true before navigating to the page.
More info: [example](https://qlevar-router.netlify.app/#/await-result) | [example code](example\lib\pages\await_result\await_result_view.dart) | [tests](test\waiting_results_test.dart).

```dart

/// navigate to the page using
final result = await QR.to<String>('/page', waitForResult: true);
// or by name
final result = await QR.toName<String>('page', waitForResult: true);

/// in the page you want to get the result from
QR.back('result');

```

## Restoration management

To enable the restoration in the app you need to set `QRouterDelegate.restorationScopeId` and set `QRoute.pageType.restorationId` to the route you want to restore.
or you set `QR.settings.autoRestoration` to true and the package will set the restoration id for you.

**Note:** don't forget to set `MartialApp.restorationScopeId`.


## Other features

- **NavigatorState**: if you want to set the navigator state in the app, you can do so by pass it to `QRouterDelegate.navkey` when creating the `RouterDelegate`.
- **BuildContext**: you can get the current context from any where by calling `QR.context`. This will give the current context of the current navigator.
- **InitPage**: The default page to show when the app starts until the first route is loaded. you can change it by setting `QR.settings.initPage` to the page you want to show.

## Add or remove routes in run Time

You can add new routes or delete the existing route from the route tree dynamically while the app is running.
Just chose which navigator you want to add the routes to and then call

```dart
final navigator = QR.rootNavigator; // to add routes to the root navigator
final navigator = QR.navigatorOf('/dashboard') // or add the routes to the dashboard navigator
navigator.addRoutes([QRoute(path: '/payrolls', builder:()=> PayrollsPage()]);
// now the use can navigate to the payrolls page
navigator.removeRoutes(['/payrolls']);
// now if the use navigate to the payrolls page he will get not found page
```

## Clean Structure

You can split your route definition into multiple files so the route tree doesn't get too messy, or if you work with multiple Teams so each team can have his tree definition.

```dart
class StoreRoutes {
  static const store = 'Store';
  static const orders = 'Orders';
  static const items = 'Items';

  QRoute routes() => QRoute.withChild(
          name: store,
          path: '/store',
          builderChild: (child) => StorePage(child),
          initRoute: '/orders',
          children: [
            QRoute(name: items, path: '/items', builder: () => ItemsPage()),
            QRoute(name: orders, path: '/orders', builder: () => OrderPage()),
          ]);
}

class HomeRoutes {
  static const home = 'Home';
  static const info = 'Info';
  static const settings = 'Settings';

  QRoute routes() => QRoute.withChild(
          name: home,
          path: '/store',
          builderChild: (child) => StorePage(child),
          initRoute: '/info',
          children: [
            QRoute(name: info, path: '/info', builder: () => InfoPage()),
            QRoute(
                name: settings,
                path: '/settings',
                builder: () => SettingsPage()),
          ]);
}

class AppRoutes {
  static const app = 'App';
  List<QRoute> routes() => [
        QRoute.withChild(
            name: app,
            path: '/',
            builderChild: (child) => AppPage(child),
            initRoute: '/store',
            children: [
              StoreRoutes().routes(), // Add the Store routes to the app
              HomeRoutes().routes(), // Add the Home routes to the app
            ]),
      ];
}
```

## Testing

For easy testing you can use `RouteMock` so when navigating while testing you can give which widget should be shown.
E.x: you have a widget that when clicking on in should navigate to the HomeView. In normal case to test this you should add QRouterDelegate so when clicking on the widget the test wont fail and show the page. But in this case we only what to test if this button send the request to package in a correct way.

```dart
void main() {
  testWidgets('RouteMock', (tester) async {
    // Set up env
    QR.reset();
    QR.settings.mockRoute = _RouteMock();
    
    // add widget and test it
    await tester.pumpWidget(const MaterialApp(home: _TestWidget()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.done));
    await tester.pumpAndSettle();
    // check if the widget sent the request to qlevar_Router
    expect(QR.currentPath, '/home');
  });
}

class _RouteMock extends RouteMock {
  @override
  String? mockName(String name) {
    return null;
  }

  @override
  QRoute? mockPath(String path) {
    // Check if qlevar_router has received a request to go to the home page
    // if so, then return empty page so the test can pass.
    // if not, the test will fail, becurse you are trying to navigate without setting the QRouterDelegate
    if (path == '/home') {
      return QRoute(path: '/home', builder: () => const SizedBox.shrink());
    }
    return null;
  }
}

class _TestWidget extends StatelessWidget {
  const _TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IconButton(
        onPressed: () {
          QR.to('/home');
        },
        icon: const Icon(Icons.done),
      ),
    );
  }
}
``` 

## Declarative routing

if you want to change a page automatically according to an object state with having to check the object every time and then send the user to the right page. you can do so with the declarative routing.
just link the object to `QDeclarative` and define the route to go to with every object change a let the rest to`QDeclarative`.

This is very useful when you have an object with a lot of properties that users need to fill. instead of one page with a lot of TextInputs (what is boring), you can split your object properties through multiple pages. and the user can fill them as flow one page at a time.

**Note**: you don't need to define these routes in the AppRoute routes.

First you need to define the parent root of the declarative route as declarative. and here you will get a key you need to pass it to `QDeclarative`.

```dart
   QRoute.declarative(path: '/declarative',declarativeBuilder: (k) => DeclarativePage(k)),
```

Then in the `DeclarativePage` in the build function give as widget a `QDeclarative`

The `QDeclarative` required two parameters

- routeKey: key you got from QRoute
- builder: List of type `List<QDRoute>` of the route to return based on the state [See QDRoute](#qdroute)

```dart
QDeclarative(
      routeKey: widget.dKey, // give the key you got from QRoute
      builder: () => [ 
               name: 'Hungry',
              builder: () =>getQuestion((v) => state.loveCoffee = v, 'Do you love Coffee?'),
              when: () => state.loveCoffee == null,
              // when this route pop, if you want to get out of the declarative
              // router give false as result so the router know that this
              // function didn't processed the pop and process it
              onPop: () => false,
            ),
            QDRoute(
                name: 'Burger',
                builder: () => getQuestion((v) => state.loveBurger = v, 'Do you love burger?'),
                onPop: () => state.loveCoffee = null,
                when: () => state.loveBurger == null),
            QDRoute(
                name: 'Pizza',
                builder: () => getQuestion((v) => state.lovePizza = v, 'Do you love Pizza?'),
                onPop: () => state.loveBurger = null,
                when: () => state.lovePizza == null,
                pageType: QSlidePage(offset: Offset(-1, 1))),
            QDRoute(
                name: 'Result',
                builder: result,
                onPop: () => state.lovePizza = null,
                when: () => state.allSet)
          ]));
```

### QDRoute

This route is used with `QDeclarative` to define the pages to show according to the object state:

- **name:** this name will be used as a key to define the route.
- **builder:** here you give the widget to show.
- **when:** when should the page be shown. here you can set the condition that defines if the page should be added to the page list.
- **onPop:** this function will be called when the user what to go back, this will be trigger with `QR.back`, android back button, and browser back button. if you want on a page to get out of the `QDeclarative` to the previews page in the normal router give this function a false as a result so the router knows that this page has not been processed and the router needs to process it.
- **pageType**: [The page Transition](#page-transition)

### How Declarative router works

On every rebuild on the page the `QDeclarative` will call `QDeclarative.builder` and get the ** the First page* the returns true from `QDRoute.when` and then checks if the page exists in the page list, if yes all pages above it will be removed so the page will be on the top and be shown. If no will add it on the top and the page will be shown.

## Remove Url Hashtag

If you what to remove the hashtag from the URL place it in your main method

```dart
void main() {
  QR.setUrlStrategy();
  runApp(MyApp());
}
```

*Note:* sometimes in release mode you could get an error when you remove the hashtag, to fix it please see [this](https://github.com/SchabanBo/qlevar_router/issues/10)

## Web hot reload

According to [This](https://github.com/flutter/flutter/issues/53041#issuecomment-828943000) the hot reload feature could take some time unit it is ready.
So I took this [idea](https://github.com/flutter/flutter/issues/53041#issuecomment-829044969) and I made a fake BrowserAddressBar. so we can develop our application on Windows or Linux or Android and still having the BrowserAddressBar. This bar will only appear on debug mode and when the platform is not web.

To activate it.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: QRouteInformationParser(),
      routerDelegate: QRouterDelegate(AppRoutes().routes, withWebBar: true));
}
```

## Articles

- [Building an app using Cubit and qlevar_router](https://medium.com/@SchabanBo/building-an-app-using-cubit-and-qlevar-router-481fba0f2349)
- [Reduce your flutter web app loading time](https://medium.com/@SchabanBo/reduce-your-flutter-web-app-loading-time-8018d8f442)
- [Implementing Deep Linking in Flutter Using the qlevar_router](https://medium.com/@SchabanBo/implementing-deep-linking-in-flutter-using-the-qlevar-router-package-9bde293e3fe0)
- [TabBar and BottomNavigationBar in flutter with qlevar_router](https://medium.com/@SchabanBo/tabbar-and-bottomnavigationbar-in-flutter-with-qlevar-router-893b1c476134)
- [Implementing Deep Linking in Flutter Using the qlevar_router Package](https://medium.com/@SchabanBo/implementing-deep-linking-in-flutter-using-the-qlevar-router-package-9bde293e3fe0)

## Projects

- [Localic](https://github.com/SchabanBo/localic): A local management application uses [riverpod](https://riverpod.dev) as state management.

## Well tested

The package is well tested, and I will keep adding more tests to make sure the package is stable.
As a navigation package it is very important to test every single scenario to make sure the package is stable. because a small change in defining the route could lead to missing param or a wrong path in the url.
That is why beside the default tests, i add a [test](https://github.com/SchabanBo/qlevar_router/tree/master/test) for every single scenario i got from the users. you can see the tests in the [scenario-code](https://github.com/SchabanBo/qlevar_router/tree/master/test/scenario-code) folder.

## Contribute

Any Contributing is welcome, You could help with writing test. More example, or any new ideas to the package
