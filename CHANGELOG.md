# CHANGELOG

## [1.0.0]

I have rewrite the entire library to add more use cases and optimize the Performance and add null safety.

## [0.3.6]

- Optimize pop behaver, now with `QR.back` if the current page can pop it will pop, otherwise it will be created.
- Finish and test `childOf` NavigationMode.
- Browser Back button will pop too if it can.
- Fix some minor issues.
- Add `DebugStackTreeWidget`.
- Save more information about the route history.

## [0.3.5] 17.02.2021

- Fix Error with extra slash at the end of the route.
- Fix custom transition issue (@rockingdice)
- Fix null exception with not found page.
- Group multi path prefix.
- Add `canChildNavigation` to `QRouteChild`.

## [0.3.4] 15.02.2021

- Add `QParams` with `onChanged` and `onDelete`.
- Add `QRouteChild` with `onChildCalled` and `currentChild`.
- **Breaking Change** Replace QRouter with QRouteChild and use QRouteChild.childRouter to get the QRouter.

## [0.3.3] 12.02.2021

- Add NavigationMode [beta]

## [0.3.2] 05.02.2021

- Fix settings last part of route as component when the param change.
- change QR.params from Map<String,dynamic> to Map<String,String> and add toInt and ToDouble extensions.
- Add justUrl to `QR.to` `QR.toNamed` just to update the url.

## [0.3.1] 03.02.2021

- Fix NavigationType for `Push`, `Pop`, `PopUnitOrPush`, `ReplaceAll`, `ReplaceLast`.
- Add InitRoute for QRoute.

## [0.3.0] 28-01-2021

- Fix Router update parent when it it component.
- Add Page Types `QRPlatformPage`, `QRMaterialPage`, `QRCupertinoPage`,  `QRCustomPage` and `QRSlidePage`.
- Better Tree Logging and method so the user can log it.

## [0.2.5] 24-01-2021

- Set route info before onInit to use it when it needed.

## [0.2.4] 24-01-2021

- Don't redirect to init Page after hot restart.

## [0.2.3] 23-01-2021

- Fix missing Component from last route.
- Add Default init Route for children.

## [0.2.2] 19-01-2021

- Fix Back and foreword buttons on browser.
- Fix Back button on mobile closes the app.
- Fix Fix multi key problem after back.
- Add Custom logger.
- Fix History Error when back two times (@obadajasm)

## [0.2.1] 10-01-2021

- Fix Routes keys order.
- Add `QRouteBuilder`.
- Fix missing `onInit/onDispose`.
- Fix multi component issue.

## [0.2.0] 03-01-2021

- Add onInit/onDispose to `QRoute`.
- Add QNavigationMode (Push, PopUntilOrPush, ReplaceAll, ReplaceLast).
- Add `QR.toNamed` navigate with route name.
- Enable the scenario to define path with multi slashes `/path/to/some`.

## [0.1.0] 29-12-2020

- create nested routes.
- context-less navigation.
- not found page.
- redirect Guard.

## [0.0.1] 25-12-2020

Test release.
