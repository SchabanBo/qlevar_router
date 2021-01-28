# CHANGELOG

## [0.3.0]

- Fix Router update parent when it it component.
- Add Page Types `QRPlatformPage`, `QRMaterialPage`, `QRCupertinoPage`,  `QRCustomPage` and `QRSlidePage`

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
