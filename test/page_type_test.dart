import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:qlevar_router/src/pages/page_creator.dart';
import 'package:qlevar_router/src/pages/qpage_internal.dart';
import 'package:qlevar_router/src/routes/qroute_internal.dart';

Future<Type> _pageTypeFor(QPage pageType) async {
  final route = QRouteInternal.from(
      QRoute(path: '/', builder: () => Container(), pageType: pageType), '/');
  return (await PageCreator(route).create()).runtimeType;
}

void main() {
  group('Page Type', () {
    test('Page type to internal page type', () async {
      QR.reset();
      final pageMap = {
        const QPlatformPage(): QMaterialPageInternal,
        const QMaterialPage(): QMaterialPageInternal,
        const QCupertinoPage(): QCupertinoPageInternal,
        const QSlidePage(): QCustomPageInternal,
        const QCustomPage(): QCustomPageInternal,
        const QModalBottomSheetPage(): QModalBottomSheetPageInternal,
      };
      for (var item in pageMap.entries) {
        expect(await _pageTypeFor(item.key), item.value);
      }
    });

    test('QPlatformPage is a cupertino page on iOS and macOS', () async {
      QR.reset();
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
        debugDefaultTargetPlatformOverride = platform;
        expect(
            await _pageTypeFor(const QPlatformPage()), QCupertinoPageInternal);
      }
    });
  });
}
