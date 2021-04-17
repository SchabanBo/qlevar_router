import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AddRemoveRoutes extends StatefulWidget {
  final QRouter route;
  AddRemoveRoutes(this.route);
  @override
  _AddRemoveRoutesState createState() => _AddRemoveRoutesState();
}

class _AddRemoveRoutesState extends State<AddRemoveRoutes> {
  final addCon = TextEditingController();
  final removeCon = TextEditingController();
  final naviCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Remove Routes in run time'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Flexible(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        '''Add or remove routes by typing the route path in the text field.
You can find the routes under [/add-remove-routes] path
Type the url you want in the browser or the text field to navigate to it.
In the right section you can find all routes under [/add-remove-routes] so you can see the changes''',
                        style: TextStyle(fontSize: 18)),
                  ),
                  Divider(),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Container(
                          padding: const EdgeInsets.all(8),
                          width: 200,
                          child: TextField(
                              controller: addCon,
                              decoration:
                                  InputDecoration(hintText: 'Add Route'))),
                      TextButton(
                          onPressed: () {
                            widget.route.navigator.addRoutes([
                              QRoute(
                                  path: addCon.text,
                                  builder: () => AddRemoveChild(addCon.text))
                            ]);
                            setState(() {
                              // setState to update the right section
                            });
                          },
                          child: Text('Add')),
                      Spacer(),
                      Container(
                          padding: const EdgeInsets.all(8),
                          width: 200,
                          child: TextField(
                              controller: removeCon,
                              decoration:
                                  InputDecoration(hintText: 'Remove Route'))),
                      TextButton(
                          onPressed: () {
                            widget.route.navigator
                                .removeRoutes([removeCon.text]);
                            setState(() {
                              // setState to update the right section
                            });
                          },
                          child: Text('Remove')),
                      Spacer(),
                      Container(
                          padding: const EdgeInsets.all(8),
                          width: 200,
                          child: TextField(
                              controller: naviCon,
                              decoration: InputDecoration(
                                  hintText: 'Navigate to Route'))),
                      TextButton(
                          onPressed: () {
                            widget.route.navigator.push(naviCon.text);
                          },
                          child: Text('Navigate'))
                    ],
                  ),
                  Divider(),
                  Expanded(child: widget.route)
                ],
              )),
          Flexible(child: widget.route.navigator.getRoutesWidget),
        ],
      ),
    );
  }
}

class AddRemoveChild extends StatelessWidget {
  final String text;
  AddRemoveChild(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 28),
      ),
    );
  }
}
