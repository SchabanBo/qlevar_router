import 'package:qlevar_router/qlevar_router.dart';

import '../pages/editable_routes/editable_routes_view.dart';

class EditableRoutes {
  QRoute get route => QRoute.withChild(
        path: '/editable-routes',
        builderChild: (child) => AddRemoveRoutes(child),
        initRoute: '/child',
        children: [
          QRoute(path: '/child', builder: () => AddRemoveChild('Hi child')),
          QRoute(path: '/child-1', builder: () => AddRemoveChild('Hi child 1')),
          QRoute(path: '/child-2', builder: () => AddRemoveChild('Hi child 2')),
          QRoute(path: '/child-3', builder: () => AddRemoveChild('Hi child 3')),
        ],
      );
}
