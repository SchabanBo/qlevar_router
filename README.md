# Qlevar Router (QR)

The clever way to Route in your projects.

- [Qlevar Router (QR)](#qlevar-router-qr)
  - [Demo](#demo)
  - [Routes Management](#routes-management)
    - [params](#params)
    - [Not found page](#not-found-page)
  - [Nested Routing](#nested-routing)
  - [Redirecting](#redirecting)
  - [Context-less Navigation](#context-less-navigation)
  - [Objects](#objects)
    - [QRoute](#qroute)
      - [name](#name)
      - [path](#path)
      - [page](#page)
      - [redirectGuard](#redirectguard)
      - [children](#children)
      - [Example](#example)

## [Demo](http://routerexample.qlevar.de)

## Routes Management

Create the route tree for your project and navigate to between the pages very easily.

### params

send params with your route and receive them in the next page.

### Not found page

you can set your custom not found pag to show it whenever page was not found, or a default one will be set.

**Note:** the route to the not found page must be `/notfound`.

## Nested Routing

## Redirecting

you can redirect to new page whenever a page is called using the `redirectGuard`.

The `redirectGuard` give the current path als parameter and takes the new path to redirect to.
or it takes `null` so the page can be accessed.

```dart
 QRoute(
    path: '/dashboard',
    redirectGuard: (path)=> AuthService().isLoggedIn? null: '/login' )
```

## Context-less Navigation

No need for context when navigation

## Objects

### QRoute

#### name

The name of the route

#### path

The path of this route


#### page

The page to show, a normal widget.
It give the child router to place it in the parent page where it needed
when the route has no children it give null.

#### redirectGuard

a method to redirect to new page.
it gives the called path and takes the new path to navigate to, give it null when you don't want to redirect.

#### children

 the children of this route

#### Example

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
