import 'package:flutter/material.dart';

import '../../../qlevar_router.dart';
import '../../routes/qroute_children.dart';
import '../../routes/qroute_internal.dart';

// coverage:ignore-file
class RoutesChildren extends StatefulWidget {
  final List<_ExpandedQRoute> _children;
  final String parentPath;
  RoutesChildren(QRouteChildren routes, {Key? key, this.parentPath = ''})
      : _children = routes.routes.map((e) => _ExpandedQRoute(e)).toList(),
        super(key: key);
  @override
  State createState() => _RoutesChildrenState();
}

class _RoutesChildrenState extends State<RoutesChildren> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget._children.length,
        itemBuilder: (c, i) => widget._children[i].route.children == null
            ? QRouteInfo(widget._children[i].route.route, widget.parentPath)
            : ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                childrenPadding: const EdgeInsets.only(left: 15),
                title: QRouteInfo(
                    widget._children[i].route.route, widget.parentPath),
                children: [
                    RoutesChildren(widget._children[i].route.children!,
                        parentPath: widget.parentPath +
                            widget._children[i].route.route.path)
                  ]));
  }
}

class QRouteInfo extends StatelessWidget {
  final QRoute route;
  final String parentPath;
  const QRouteInfo(this.route, this.parentPath, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        onTap: () => QR.to(parentPath + route.path),
        title: Text(
            // ignore: lines_longer_than_80_chars
            "Path: ${route.path} ${(route.name == null ? '' : ('  -  Name: ${route.name!}'))}"),
      ),
    );
  }
}

class _ExpandedQRoute {
  final QRouteInternal route;
  bool isExpanded = false;
  _ExpandedQRoute(this.route);
}
