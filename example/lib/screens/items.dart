import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/database.dart';
import '../helpers/date_time.dart';
import '../routes.dart';

class ItemsScreen extends StatelessWidget {
  final QRouter routerChild;
  ItemsScreen(this.routerChild);

  final database = Get.find<Database>();

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
          Wrap(
            children: database.items
                .map((e) => InkWell(
                      // onTap: () => QR.to(
                      //     '/dashboard/items/details?itemName=${e.name}'), OR
                      onTap: () => QR.toName(AppRoutes.itemsDetails,
                          params: {'itemName': e.name},
                          type: NavigationType.Push),
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
          SizedBox(height: 350, child: routerChild),
        ],
      ),
    );
  }
}

class ItemDetailsScreen extends StatelessWidget {
  final database = Get.find<Database>();

  @override
  Widget build(BuildContext context) {
    final item = database.items.firstWhere(
        (element) =>
            element.name == QR.currentRoute.params['itemName'].toString(),
        orElse: () => StoreItem(id: 0));

    return Card(
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
