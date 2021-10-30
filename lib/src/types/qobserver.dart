import '../routes/qroute.dart';

class QObserver {
  /// add listners to every new route that will be added to the tree
  final onNavigate = <Future Function(String, QRoute)>[];

  /// Add listner to every route that will be deleted from the tree
  final onPop = <Future Function(String, QRoute)>[];
}
