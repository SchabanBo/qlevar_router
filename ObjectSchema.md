# Schema

## Objects

### QRouter

It works in replace with getMaterialApp.router

- Pages
- initRoute

### QPage

- key
- page (childRouter) =>
- route string
- children list of QPage

### QR

- push
- pop
- replace
- replaceAll

## Example

- Store `/store`
  - Items `/store/items`
    - Item `store/items/2`
- Dashboard `/dashboard`
  - ItemsManagement `/dashboard/items`
    - Item `/dashboard/items/4`
  - All Orders `/dashboard/orders`
    - Details `/dashboard/orders/4`
      - OrderItem `/dashboard/orders/3/items/4`

## Notes

QRouter => MaterialApp => routeDelegate

Every delegate should have a QRNotifer linked with key

if user writes in the browser :

- parseRouteInformation
- search the delegate in tree from parser
- setNewRoutePath

if user called push:

- search the delegate in tree from RQExtensions
- change the stack
- currentConfiguration will be called
- restoreRouteInformation (here i have to rebuild the complete URL)
