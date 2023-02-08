# CHANGELOG

## Current

- Throw exception if the route name is not unique.
- Cleanup analyzer warnings.
- Fix #101

### Breaking changes

- (Add #105) Replaced milli-seconds by Duration in PageTransition @tejHackerDEV

## [1.7.1] 12.11.2022

- Fix #90.
- Fix path will sometime not update when PageAlreadyExistAction.BringToTop is set.
- add `RouteMock`
- Fix #86 @tejHackerDEV

## [1.7.0] 27.10.2022

- Add #84
- Add RouterState
- Add #86
- Fix #88
- Add #81

## [1.6.4] 31.08.2022

- Fix middlewares of children router will not be called when parent removed.

## [1.6.3] 31.08.2022

- Fix #73
- Readme update
- QParams improvements to solve #77

## [1.6.2] 19.07.2022

- Fix #72
- Add Tests
- Code cleanup

## [1.6.1] 03.07.2022

- Fix #69

## [1.6.0] 01.07.2022

- remove QDialog
- cleanup and fix some typos

## [1.5.11] 04.03.2022

- Redesign example
- Remove QNotification
- Add more tests

## [1.5.10] 28.02.2022

- Fix #56
- Fix Typos

## [1.5.9] 21.12.2021

- Fix blank screen when middleware is working and no page in the stack

## [1.5.8] 30.11.2021

- Add `QR.IsSamePath`, `QR.isSameName`
- #47, #50 ,#51

## [1.5.7] 27.11.2021

- Add PageAlreadyExistAction to `to` and `toName`
- Add switchTo
- Add switchToName

## [1.5.6] 21.11.2021

- Add update params options to updateUrl

## [1.5.5] 31.10.2021

- Fix init route when ignoring the path.

## [1.5.4] 30.10.2021

- Fix navigating with name under a navigator
- Add '/!' to ignore the segment in the path
- Add `QR.settings.oneRouteInstancePerStack`
- Add `QR.observer` to add listeners to every new route will be added or old route will be deleted [#42]
- [#42] Fix `QR.navigator.replace`
- [#43] Support for navigator observers @basmilius

## [1.5.3] 14.10.2021

- Fix #40 @Sociosarbis
- Fix url encoding when there is white space in the url
- #42

## [1.5.2] 23.09.2021

- Fix #37
- Fix exception if the URL ended with extra /

## [1.5.1] 13.09.2021

- Change pop result to PopResult
- Fix CanPop not working on first page

## [1.5.0] 07.09.2021

- Convert `QMiddleware.canPop` ,`QMiddleware.onMatch` ,`QMiddleware.onEnter` and `QMiddleware.onExit` to accept Async.
- `QR.back()` will close the dialog if one is open

### Breaking changes

- `QR.back()` is awaitable.

## [1.4.4] 06.07.2021

- Fix Init Path shown first when opening the website to a specific path
- Add iniPage in settings
- Add `QRouterDelegate.alwaysAddInitPath`

## [1.4.3] 03.07.2021

- Fix notification assert
  
## [1.4.2] 29.06.2021

- Add `redirectGuardName` [#24]
- Implement `Replace`, `ReplaceName`, `replaceLastName` and `replaceLast`
- Add `.QNotification.widgetBuilder` so the notification can be remove programmlcly.
- Fix [#26]
- Fix routing problem with child router.

## [1.4.1] 20.05.2021

- Add `QR.settings.pagesType`
- `QCustomPage` can be mix
- Add `QFadePage` [#22](https://github.com/SchabanBo/qlevar_router/issues/22)

## [1.4.0] 11.05.2021

- Fix [#20](https://github.com/SchabanBo/qlevar_router/issues/20)
- Add `QNotification`

## [1.3.0] 29.04.2021

- Fix `QR.params.ensureExist` [#18]
- Add `QDeclarative` declarative Router
- Add `cleanupAfter` to `QParam`
- Add `Fake BrowserAddressBar`

## [1.2.0] 17.04.2021

- Fix [#17], Path not updated with `QR.navigatorOf().replaceAll`
- Fix notFoundPage path in nested navigator
- Add `AddRoutes` and `RemoveRoute`
- Route.path can be without slash at the start.
- Add `QDialog`, so user can open dialogs.

## [1.1.4] 12.04.2021

- Fix [#17](https://github.com/SchabanBo/qlevar_router/issues/17)

## [1.1.3] 05.04.2021

- code cleanup
- Make route params available in redirectGuard
- Add Route Tree widget

## [1.1.2] 03.04.2021

- Fix [#16](https://github.com/SchabanBo/qlevar_router/issues/16)
- Fix Problem when using Middleware with nested child.

## [1.1.1] 28.03.2021

- Fix [#11](https://github.com/SchabanBo/qlevar_router/issues/11)
- Fix back button on not found page.

## [1.1.0] 19.03.2021

- Fix Extra Slash at the end of Url
- Remove Url Strategy
- Fix init Route with child
- Make QParamValue as object instated of string
- Fix multi path case '/:userId/settings' (Component and then normal path)
- Add canPop for the Middleware
- Give the path in middleware redirect guard
- Add ignoreSamePath to `to` and `toName`

## [1.0.0] 13.03.2021

I have rewrite the entire library to add more use cases and optimize the Performance and add null safety.

## [0.3.5+2] 28.02.2021

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
