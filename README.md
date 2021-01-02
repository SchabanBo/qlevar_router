# Qlevar Router (QR) [Demo](http://routerexample.qlevar.de)

The clever way to Route in your projects.

- [Qlevar Router (QR) Demo](#qlevar-router-qr-demo)
  - [Using](#using)
    - [Installing](#installing)
    - [Configuration](#configuration)
    - [Params](#params)
    - [Not found page](#not-found-page)
    - [Nested Routing](#nested-routing)
    - [Redirecting](#redirecting)
    - [Context-less Navigation](#context-less-navigation)
    - [Known issues](#known-issues)
  - [Classes](#classes)
    - [QRoute](#qroute)
    - [QR](#qr)

## Using

### Installing

Use this package as a library
1. Depend on it
Add this to your package's pubspec.yaml file:
``` 
dependencies:
  qlevar_router:
```   
2. Install it
You can install packages from the command line:

with Flutter:
``` 
$ flutter pub get
``` 

3. Import it
Now in your Dart code, you can use:

```dart
import 'package:qlevar_router/qlevar_router.dart';
```

### Configuration

To use this package you must first use the Router with the `MaterialApp` or `CupertinoApp`. and give the package router and parser to the app.

```dart
 MaterialApp.router(
        routerDelegate: QR.router(routes, initRoute: '/dashboard'),
        routeInformationParser: QR.routeParser(),
      )
```

`routes` are the list of QRoute that represent the routes for your project.

`initRoute` is optional, when it is not provided the route `/` will be used.

### Params

send params with your route and receive them in the next page.

you can set the params as:

- route component:

```dart
QRoute(path: '/:orderId',page: (child) => OrderDetails()),

// and this receive it in your page
final orderId = QR.currentRoute.params['orderId'].toString()
```

- or als query param

```dart
 QR.replace('/dashboard/items/details?itemName=${e.name}&numbers=[2,6,7]')

// and this receive it in your page
final itemName = QR.currentRoute.params['itemName'].toString()
final numbers = QR.currentRoute.params['numbers']
```

### Not found page

you can set your custom not found pag to show it whenever page was not found, or a default one will be set.

**Note:** the route to the not found page must be `/notfound`.

### Nested Routing

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

### Redirecting

you can redirect to new page whenever a page is called using the `redirectGuard`.

The `redirectGuard` give the current path als parameter and takes the new path to redirect to.
or it takes `null` so the page can be accessed.

```dart
 QRoute(
    path: '/dashboard',
    redirectGuard: (path)=> AuthService().isLoggedIn? null: '/login' )
```

### Context-less Navigation

No more need for context when you want to navigate.
if you need to route to new page simply

```dart
  QR.to('/dashboard/items');
```

and QR is clever enough to know with `Router` he should update.

want to go back

```dart
  QR.back();
```

### Known issues

- Back and foreword buttons on browser not working as expected.
- Back button on mobile closes the app.
- for now just the MaterialApp/MaterialPage are implemented.

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

- **to(String path)**: navigate to new path, call this method from anywhere and QR is clever enough to know which router he should update.
- **back()**: navigate back to a previous page.
- **history**: list of string for the paths that has been called.
- **currentRoute**: The information for the current route.
  - **fullPath**: the full path of the current route.
  - **params**: Map<String,dynamic> contains the params for the current route.
