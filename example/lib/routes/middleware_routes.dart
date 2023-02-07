import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../pages/middleware/child_view.dart';
import '../pages/middleware/middleware_view.dart';
import '../services/storage_service.dart';
import 'store_routes.dart';

class MiddlewareRoutes {
  QRoute get route => QRoute(
        name: 'Parent',
        path: '/parent',
        builder: () {
          debugPrint('-- Build Parent page --');
          return const MiddlewareView();
        },
        middleware: [
          QMiddlewareBuilder(
            onMatchFunc: () async => debugPrint('-- Parent page Matched --'),
            onEnterFunc: () async => debugPrint('-- Enter Parent page --'),
            onExitFunc: () async => debugPrint('-- Exit Parent page --'),
            onExitedFunc: () => debugPrint('-- Parent page Exited--'),
          )
        ],
        children: [
          QRoute(
              path: '/child-1', builder: () => const ChildView('Hi child 1')),
          QRoute(
            path: '/child-2',
            middleware: [
              QMiddlewareBuilder(
                redirectGuardFunc: (s) => Future.delayed(
                  const Duration(milliseconds: 100),
                  () => Get.find<StorageService>().canNavigateToChild
                      ? null
                      : '/parent/child-1',
                ),
              )
            ],
            builder: () => const ChildView('Hi child 2'),
          ),
          QRoute(
            path: '/child-3',
            middleware: [
              QMiddlewareBuilder(
                redirectGuardNameFunc: (s) => Future.delayed(
                  const Duration(milliseconds: 100),
                  () => const QNameRedirect(
                    name: StoreRoutes.storeId,
                    params: {'id': '2'},
                  ),
                ),
              )
            ],
            builder: () => const ChildView('Hi child 3'),
          ),
          QRoute(
            path: '/child-4',
            builder: () => const ChildView('Should this child pop?'),
            middleware: [
              QMiddlewareBuilder(
                canPopFunc: () async {
                  final result = await showDialog<bool>(
                      context: QR.context!, builder: dialog);
                  return result ?? false;
                },
              )
            ],
          ),
        ],
      );

  AlertDialog dialog(BuildContext context) => AlertDialog(
        title: const Text('Do you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          )
        ],
      );
}
