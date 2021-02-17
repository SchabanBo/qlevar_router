# Features

- [Features](#features)
  - [Routing](#routing)
    - [Nested Routing - Widget Update](#nested-routing---widget-update)
    - [What is it](#what-is-it)
      - [Example](#example)
      - [To use the nested routing](#to-use-the-nested-routing)
  - [Context-less Navigation](#context-less-navigation)
  - [Params](#params)
  - [Redirecting](#redirecting)
  - [Not found page](#not-found-page)

## Routing

### Nested Routing - Widget Update

### What is it

There are cases when we need to change the route of the application without changing the entire page and without losing the state of the current page simply i want to update a part in it with a new route (common case is bottom navigation bar, sidebar in a dashboard, etc). That was so hard to accomplish in flutter unit now.

#### Example

We have this page that show us the orders
https://routerexample.qlevar.de/#/dashboard/orders/
the code for this page is [here](https://github.com/SchabanBo/qlevar_router/blob/master/example/lib/screens/dashboard/orders.dart)

now click on any order (lets say order 3) to see the info for it and you will be navigate to new a route
https://routerexample.qlevar.de/#/dashboard/orders/3

lets take a look on the time when the page was created (the time is next to the `Order` word in the top center)
when you navigate between the orders the time doesn't change because the state of the order page doesn't change we did not use any state management here (The widget is Stateless) we just navigate in the child in it.

and the routes for this page are defined lis this

```dart
 QRoute(
  name: dashboard,
  path: '/dashboard',
  page: (childRouter) => DashboardScreen(childRouter),
  children: [
    QRoute(
    name: orders,
    path: '/orders',
    page: (child) => OrdersScreen(child),
    children: [
      QRoute(
          name: ordersDetails,
          path: '/:orderId',
          pageType: QRSlidePage(
            transitionDurationmilliseconds: 500,
            offset: Offset(1, 0),
          ),
          page: (child) => OrderDetails()),
    ])
  ])

```

#### To use the nested routing

- Define the children for a route with [QRoute](#QRoute) or [QRouteBuilder](#QRouteBuilder)

```dart
  QRoute(
    name: 'Items',
    path: '/items',
    page: (childRouter) => ItemsScreen(childRouter),
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

- then a router for this children will be created and you get this router in the `page` property of the parent in out example the router is `childRouter`

- Then you can place it wherever you like in your page

```dart
class ItemsScreen extends StatelessWidget {
  final QRouteChild child;
  ItemsScreen(this.child);

  final database = Get.find<Database>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ...
          // any code or widgets you want
          // ...

          child.childRouter,
        ],
      ),
    );
  }
}

```

and leave the rest for the package.

now when you navigate from `/items/new` to `/item/details` only the `ItemDetailsScreen` widget will be replaced with `AddItemScreen` and any other widget in your `ItemsScreen` will be the same

## Context-less Navigation

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

## Params

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
 QR.to('/dashboard/items/details?itemName=${e.name}&numbers=[2,6,7]')

// and this receive it in your page
final itemName = QR.params['itemName'].toString()
final numbers = QR.params['numbers']
```

## Redirecting

you can redirect to new page whenever a page is called using the `redirectGuard`.

The `redirectGuard` give the current path als parameter and takes the new path to redirect to.
or it takes `null` so the page can be accessed.

```dart
 QRoute(
    path: '/dashboard',
    redirectGuard: (path)=> AuthService().isLoggedIn? null: '/login' )
```

## Not found page

you can set your custom not found page to show it whenever page was not found, or a default one will be set.

to define you custom not found page just add a route with the path '/notfound' in the main routes

```dart
 final routes = <QRouteBase>[
    QRoute(
        name: 'Home',
        path: '/home',
        page: (childRouter) => HomeScreen(childRouter)),
    QRoute(
        name: 'Not Found',
        path: '/notfound',
        page: (_) => NotFoundPage()),
  ];
```

**Note:** the route to the not found page must be `/notfound`.
