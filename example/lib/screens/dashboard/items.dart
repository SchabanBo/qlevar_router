import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/database.dart';
import '../../helpers/date_time.dart';
import '../../routes.dart';

class ItemsScreen extends StatefulWidget {
  final QRouteChild child;
  ItemsScreen(this.child);
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final database = Get.find<Database>();
  bool isState = false;
  String selectedItem = QR.currentRoute.params['itemName'].toString();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Items',
            style: TextStyle(color: Colors.white, fontSize: 35),
          ),
          const SizedBox(width: 15),
          Text(
            'Created $now',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            'You can update the child by State managment or by Navigation',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  value: isState,
                  onChanged: (v) {
                    setState(() {
                      isState = v;
                    });
                  }),
              Text(
                'State managment',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Checkbox(
                  value: !isState,
                  onChanged: (v) {
                    setState(() {
                      isState = !v;
                    });
                  }),
              Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
          Wrap(
            children: database.items
                .map((e) => InkWell(
                      // onTap: () => QR.to(
                      //     '/dashboard/items/details?itemName=${e.name}'), OR
                      onTap: () {
                        if (isState) {
                          setState(() {
                            selectedItem = e.name;
                          });
                          QR.toName(AppRoutes.itemsDetails,
                              params: {'itemName': e.name},
                              type: NavigationType.Push,
                              justUrl: true);
                        } else {
                          QR.toName(AppRoutes.itemsDetails,
                              params: {'itemName': e.name},
                              type: NavigationType.Push);
                        }
                      },
                      child: Card(
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.asset(
                              e.image,
                              width: 150,
                              height: 150,
                            ),
                            Container(
                              width: 150,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  )),
                              child: Center(
                                child: Text(
                                  e.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          Wrap(
            children: [
              Column(
                children: [
                  Text(
                    'State managment',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  ItemDetailsScreen(itemName: selectedItem),
                ],
              ),
              const SizedBox(width: 150),
              Column(
                children: [
                  Text(
                    'Navigation',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                      width: 350, height: 350, child: widget.child.childRouter),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ItemDetailsScreen extends StatelessWidget {
  final database = Get.find<Database>();
  final String itemName;
  ItemDetailsScreen({this.itemName});
  @override
  Widget build(BuildContext context) {
    final item = database.items.firstWhere(
        (element) =>
            element.name ==
            (itemName ?? QR.currentRoute.params['itemName'].toString()),
        orElse: () => null);

    return item == null
        ? Container()
        : Card(
            child: Column(
              children: [
                Text(
                  '${QR.currentRoute.params['itemName']} Details',
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  'Created $now',
                  style: TextStyle(fontSize: 20),
                ),
                Image.asset(
                  item.image,
                  height: 200,
                  width: 200,
                ),
                Text('Id: ${item.id}'),
                Text('Price ${item.price}'),
              ],
            ),
          );
  }
}
