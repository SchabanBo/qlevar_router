import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:qlevar_router/src/pages/page_creator.dart';
import 'package:qlevar_router/src/pages/qpage_internal.dart';
import 'package:qlevar_router/src/routes/qroute_internal.dart';

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
      };
      for (var item in pageMap.entries) {
        final route = QRouteInternal.from(
            QRoute(path: '/', builder: () => Container(), pageType: item.key),
            '/');
        final resultType = PageCreator(route).create().runtimeType;
        expect(resultType == item.value, true);
      }
    });
  });
}
