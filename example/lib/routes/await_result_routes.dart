import 'package:qlevar_router/qlevar_router.dart';

import '../pages/await_result/await_result_view.dart';
import '../pages/await_result/get_result_view.dart';

class AwaitResultRoutes {
  static const name = 'awaitResultRoute';
  static const getResult = 'GetResult';

  final route = const QRoute(
    path: '/await-result',
    name: name,
    builder: AwaitResultView.new,
    children: [
      QRoute(
        path: '/get-result',
        name: getResult,
        builder: GetResultView.new,
      ),
    ],
  );
}
