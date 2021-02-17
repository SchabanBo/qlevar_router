# Define Routes

- [Define Routes](#define-routes)
  - [QRoute](#qroute)
    - [QRouteChild](#qroutechild)
  - [QRouteBuilder](#qroutebuilder)

## QRoute

- **name**:
The name of the route
- **path**:
The path of this route
- **page**:
The page to show, a normal widget.
It gives [QRouteChild](#qroutechild) to use it in the parent page where it needed
when the route has no children it give null.
- **onInit**: a function to do what you need before initializing the route.
- **onDispose**: a function to do what you need before disposing the route. for example For example `onInit`and `onDispose` are very useful to use with Getx.
  
  ```dart
  QRoute(
    name: 'Items Details',
    path: '/details',
    onInit: () => Get.put(ItemsController),
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
                    name: 'Items Details',
                    path: '/details',
                    page: (child) => ItemDetailsScreen())
              ]),
        ]),
```

- **InitRoute**: Set the initialize route for this route when it has children. This value will not be used if the route has no children. The child will be created but the path will not be changed. in the example when the route `/Item` called the `ItemsScreen` page will be created and the child will be `ItemDetailsScreen` but the path will stay `/items` not `/items/details`

```dart

  QRoute(
    name: 'Items',
    path: '/items',
    initRoute:'/details', // This child will be created when the path is '/items'
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

### QRouteChild

this object will be given from the QRoute.page function and it contains:

- **ChildRouter:** a widget to place it in your page where you want the children of this route to be displayed. The widget updates according to route.
- **child:** the `QRoute` route that is currently displayed. it can be only a child from the parent route.

## QRouteBuilder

When you work on a large project the router class will start to get too big and messy and here when `QRouteBuilder` come to help.

Split the the router to multiple files and call them from the root router or as child to another page.

See `OrdersRoutes` class in [example routes.dart](https://github.com/SchabanBo/qlevar_router/blob/8915254889da4993afd23ea69d17657be30095ec/example/lib/routes.dart)

``` dart

// Define the sub router.
class OrdersRoutes extends QRouteBuilder {
  static String orders = 'Orders';
  static String ordersMain = 'Orders Main';
  static String ordersDetails = 'Orders Details';

  @override
  QRoute createRoute() => QRoute(
          name: orders,
          path: '/orders',
          page: (child) => OrdersScreen(child),
          children: [
            QRoute(
                name: ordersDetails,
                path: '/:orderId',
                page: (child) => OrderDetails()),
          ]);
}

// Link it to the root route or as child to another page
  final routes = <QRouteBase>[
    QRoute(
        name: dashboard,
        path: '/dashboard',
        page: (childRouter) => DashboardScreen(childRouter),
        children: [
          QRoute(
              name: dashboardMain,
              path: '/',
              page: (child) => DashboardContent()),      
          OrdersRoutes(), // Here is the call
        ])
  );

```
