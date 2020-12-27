# Qlevar Router (QR) [Demo](http://routerexample.qlevar.de)

The clever way to Route in your projects.

- [Qlevar Router (QR) Demo](#qlevar-router-qr-demo)
  - [Using](#using)
    - [Configuration](#configuration)
      - [Params](#params)
      - [Not found page](#not-found-page)
    - [Nested Routing](#nested-routing)
    - [Redirecting](#redirecting)
    - [Context-less Navigation](#context-less-navigation)
  - [Classes](#classes)
    - [QRoute](#qroute)

## Using

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

#### Params

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

#### Not found page

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

No need for context when navigation

## Classes

### QRoute

- name

The name of the route

- path

The path of this route

- page

The page to show, a normal widget.
It give the child router to place it in the parent page where it needed
when the route has no children it give null.

- redirectGuard

a method to redirect to new page.
it gives the called path and takes the new path to navigate to, give it null when you don't want to redirect.

- children

 the children of this route

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
