# Qlevar Router (QR) [Show Demo](https://routerexample.qlevar.de)

 [![likes](https://badges.bar/qlevar_router/likes)](https://pub.dev/packages/qlevar_router)
 [![popularity](https://badges.bar/qlevar_router/popularity)](https://pub.dev/packages/qlevar_router)
 [![pub points](https://badges.bar/qlevar_router/pub%20points)](https://pub.dev/packages/qlevar_router)

With Navigator2.0 Manage your project routes and create nested routes. Update only one widget in your page when navigating to new route. Simply navigation without context to your page.

There are cases when we need to change the route of the application but not change the entire page, just one widget in it.
I down want to loss the state of the current page but i want to change a part of it with a new route (common case is bottom navigation bar, sidebar in a dashboard, etc). That was not possible in flutter unit now.
With this package you can do this [Nested Routing - Widget Update](#nested-routing---widget-update).

The clever way to Route in your projects.

- [Qlevar Router (QR) Show Demo](#qlevar-router-qr-show-demo)
  - [Using](#using)
    - [Installing](#installing)
    - [Configuration](#configuration)
    - [InitRoute](#initroute)
    - [Nested Routing - Widget Update](#nested-routing---widget-update)
    - [Context-less Navigation](#context-less-navigation)
    - [Params](#params)
    - [Redirecting](#redirecting)
    - [Not found page](#not-found-page)
  - [Classes](#classes)
    - [QRoute](#qroute)
    - [QR](#qr)
    - [Navigation mode](#navigation-mode)

## Using

### Installing

Use this package as a library

1. Depend on it

Add this to your package's pubspec.yaml file:

``` yaml
dependencies:
  qlevar_router:
```

Install it
You can install packages from the command line:

with Flutter:

``` cm
flutter pub get
```

Import it
Now in your Dart code, you can use:

```dart
import 'package:qlevar_router/qlevar_router.dart';
```

### Configuration

To use this package you must first use the Router with the `MaterialApp` or `CupertinoApp`. and give the package router and parser to the app.

```dart
MaterialApp.router(
      routerDelegate: QR.router(routes),
      routeInformationParser: QR.routeParser())
```

`routes` are the list of QRoute that represent the routes for your project.
The path of the route should start with `/`.

### InitRoute

As default the initRoute is `/`, if you want to change it you need to give the new value to the `initRoute` in the router method

```dart
MaterialApp.router(
        routerDelegate: QR.router(AppRoutes().routes, initRoute: '/dashboard'),
        routeInformationParser: QR.routeParser(),
      );

```

### Nested Routing - Widget Update

To use the nested routing:

- simply define the children for a route

```dart

  QRoute(
    name: 'Items',
    path: '/items',
    page: (child) => ItemsScreen(child),
    children: [
      QRoute(
        name: 'Items Details',
        path: '/details',
        page: (c) => ItemDetailsScreen()),
      QRoute(
        name: 'Add Items',
        path: '/new',
        page: (c) => AddItemScreen())

```

- then a router for this children will be created and you get this router in the page property of the parent
The child parameter of page property for the route `Items`

- Then you can place it wherever you like in your page

```dart
class ItemsScreen extends StatelessWidget {
  final QRouter routerChild;
  ItemsScreen(this.routerChild);

  final database = Get.find<Database>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ...
          // any code or widgets you want
          // ...

          routerChild,
        ],
      ),
    );
  }
}

```

and leave the rest for the package.

now when you navigate from `/items/new` to `/item/details` only the `ItemDetailsScreen` widget will be replaced with `AddItemScreen` and any other widget in your `ItemsScreen` will be the same

### Context-less Navigation

No more need for context when you want to navigate.
if you need to route to new page simply

```dart

  // white the path to the page
  QR.to('/dashboard/items');

  // OR
  
  // Here the path of the route is '/dashboard/items/:itemId' and the QRoute.name = 'Item Page'
  // and the result is '/dashboard/items/3'
  QR.toName('Item Page', params:{'itemId':3})
```

and QR is clever enough to know with `Router` he should update.

want to go back

```dart
  QR.back();
```

### Params

send params with your route and receive them in the next page.

you can set the params as:

- route component:

```dart
QRoute(path: '/:orderId',page: (child) => OrderDetails()),

// and this receive it in your page
final orderId = QR.params['orderId'].toString()
```

- or als query param

```dart
 QR.replace('/dashboard/items/details?itemName=${e.name}&numbers=[2,6,7]')

// and this receive it in your page
final itemName = QR.params['itemName'].toString()
final numbers = QR.params['numbers']
```

### Redirecting

you can redirect to new page whenever a page is called using the `redirectGuard`.

The `redirectGuard` give the current path als parameter and takes the new path to redirect to.
or it takes `null` so the page can be accessed.

```dart
 QRoute(
    path: '/dashboard',
    redirectGuard: (path)=> AuthService().isLoggedIn? null: '/login' )
```

### Not found page

you can set your custom not found pag to show it whenever page was not found, or a default one will be set.

**Note:** the route to the not found page must be `/notfound`.

## Classes

### QRoute

- **name**:
The name of the route
- **path**:
The path of this route
- **page**:
The page to show, a normal widget.
It give the child router to place it in the parent page where it needed
when the route has no children it give null.
- **onInit**: a function to do what you need before initializing the route.
- **onDispose**: a function to do what you need before disposing the route. for example `onInit`and `onDispose` are very useful to use with Getx
  
  ```dart
  QRoute(
    name: 'Items Details',
    path: '/details',
    onInit: () =>Get.put(ItemsController),
    onDispose: () => Get.delete<ItemsController>(),
    page: (c) => ItemDetailsScreen())
  ```

- **redirectGuard**: a method to redirect to new page.
it gives the called path and takes the new path to navigate to, give it null when you don't want to redirect.
- **children**: the children of this route
- Example

```dart
   QRoute(
        name: 'Dashboard',
        path: '/dashboard',
        page: (childRouter) => DashboardScreen(childRouter),
        redirectGuard: (path)=> AuthService().isLoggedIn? null: '/login',
        children: [
          QRoute(
              name: 'Dashboard Main',
              path: '/',
              page: (child) => DashboardContent()),
          QRoute(
              name: 'Items',
              path: '/items',
              page: (child) => ItemsScreen(child),
              children: [
                QRoute(
                    name: 'Items Main',
                    path: '/',
                    page: (child) => Container()),
                QRoute(
                    name: 'Items Details',
                    path: '/details',
                    page: (child) => ItemDetailsScreen())
              ]),
        ]),
```

### QR

- **to(String path, [NavigationMode](#navigation-mode) mode)**: navigate to new path, call this method from anywhere and QR is clever enough to know which router he should update.
- **toName(String name, Map<String,dynamic> params, [NavigationMode](#navigation-mode) mode)**: Navigation to new route by the name, just give the name of the route and the params to add to the route and QR will build the path and navigate to it for you.
- **back()**: navigate back to a previous page.
- **history**: list of string for the paths that has been called.
- **params**:  Map<String,dynamic> contains the params for the current route.
- **currentRoute**: The information for the current route.
  - **fullPath**: the full path of the current route.
  - **params**: Map<String,dynamic> contains the params for the current route.

### Navigation mode

- **type**: an enum `NavigationType` the default type is `ReplaceLast`:
  - **Push**: place the new page on the top of the stack and don't remove the last one.
  - **PopUnitOrPush**: Pop all page unit you get this page in the stack if the page   in the stack push in on the top.
  - **ReplaceLast**: replace the last page with this page.
  - **ReplaceAll**: remove all page from the stack and place this on on the top.
