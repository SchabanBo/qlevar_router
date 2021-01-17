import '../../match_context.dart';
import '../../qr.dart';
import '../../types.dart';
import 'tree_builder.dart';
import 'tree_matcher.dart';
import 'tree_types.dart';

class RoutesTree {
  Tree _tree;
  final _matcher = TreeMatcher();

  void buildTree(List<QRouteBase> routes) {
    QR.history.clear();
    _tree = TreeBuilder().buildTree(routes);
    _matcher.tree = _tree;
    QR.log('Tree Built', isDebug: true);
  }

  MatchContext getMatch(String path) {
    return _matcher.getMatch(path);
  }

  MatchContext getNamedMatch(String name, Map<String, dynamic> params) {
    return _matcher.getMatch(_matcher.findPathFromName(name, params));
  }
}
