import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AddRemoveRoutes extends StatefulWidget {
  final QRouter route;
  const AddRemoveRoutes(this.route, {Key? key}) : super(key: key);
  @override
  State<AddRemoveRoutes> createState() => _AddRemoveRoutesState();
}

class _AddRemoveRoutesState extends State<AddRemoveRoutes> {
  final addCon = TextEditingController();
  final removeCon = TextEditingController();
  final navIcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Remove Routes in run time'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '''Add or remove routes by typing the route path in the text field.
You can find the routes under [/add-remove-routes] path
Type the url you want in the browser or the text field to navigate to it.
In the right section you can find all routes under [/add-remove-routes] so you can see the changes''',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: 200,
                      child: TextField(
                        controller: addCon,
                        decoration:
                            const InputDecoration(hintText: 'Add Route'),
                      ),
                    ),
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
                        child: const Text('Add')),
                    const Spacer(),
                    Container(
                        padding: const EdgeInsets.all(8),
                        width: 200,
                        child: TextField(
                            controller: removeCon,
                            decoration: const InputDecoration(
                                hintText: 'Remove Route'))),
                    TextButton(
                        onPressed: () {
                          widget.route.navigator.removeRoutes([removeCon.text]);
                          setState(() {
                            // setState to update the right section
                          });
                        },
                        child: const Text('Remove')),
                    const Spacer(),
                    Container(
                        padding: const EdgeInsets.all(8),
                        width: 200,
                        child: TextField(
                            controller: navIcon,
                            decoration: const InputDecoration(
                                hintText: 'Navigate to Route'))),
                    TextButton(
                        onPressed: () {
                          widget.route.navigator.push(navIcon.text);
                        },
                        child: const Text('Navigate'))
                  ],
                ),
                const Divider(),
                Expanded(child: widget.route)
              ],
            ),
          ),
          Flexible(child: widget.route.navigator.getRoutesWidget),
        ],
      ),
    );
  }
}

class AddRemoveChild extends StatelessWidget {
  final String text;
  const AddRemoveChild(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }
}
