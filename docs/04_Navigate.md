# Navigation

- [Navigation](#navigation)
  - [Example routes definitions](#example-routes-definitions)
  - [QR.to](#qrto)
    - [path](#path)
  - [QR.toName](#qrtoname)
    - [name](#name)
    - [params](#params)
  - [Common properties](#common-properties)
    - [justUrl](#justurl)
    - [type](#type)

you have to options to navigate to anew router:

- with the route path using `QR.to`
- with the route name using `QR.toName`

## Example routes definitions

we will use this routes definition for all the examples in this page.

```dart
QRoute(
  name:'Home',
  path:'/home',
  page:(c)=> HomePage(c),
  children:[
    QRoute(
      name:'Users',
      path:'/users',
      page:(c)=> UsersPage(c),
      children:[
         QRoute(
          name:'User Info',
          path:'/:userId',
          page:(c)=> UserInfoPage()
        )
      ]
    )
  ]
)
```

## QR.to

### path

this is the new route to navigate to.
the route component and the params must be in the route
Example: `/home/user/2?showAll=true`


## QR.toName

### name

this the route name that has been defined with route

if you want to navigate `UserInfoPage` you can set this parameter as `UserInfo` and don't forget to give the `userId` as [Params](#params)

### params

all the params to send with route.
it could be components like the `userId` from the example or a route params

to call this route `/home/user/2?showAll=true` you can use toName like this

```dart
QR.toName('User Info', params: { 'userId': 2,'showAll' : true })
```

## Common properties

 here are the properties that can be used with `QR.to` and `QR.toName`

### justUrl

There are some cases where we update the child widget with state management and we just want to update the browser url. if you want to do so just set this parameter to true and the package will update the tree with right widget but it will not update the screen. so widget tree will have the right widget in case the user do a page refresh and the url will be show the url for this widget.
[Example](https://routerexample.qlevar.de/#/dashboard/items) you can check the state management and click on any item. then the screen will be update (with setState) and QR.to(justUrl: true ) will be called to update the url.

### type
