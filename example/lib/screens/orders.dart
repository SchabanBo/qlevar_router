import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/database.dart';

class OrdersScreen extends StatelessWidget {
  final QRouter routerChild;
  OrdersScreen(this.routerChild);
  @override
  Widget build(BuildContext context) {
    final database = Get.find<Database>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Orders',
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            const SizedBox(width: 15),
            RaisedButton(
              child: Text('Back'),
              onPressed: QR.back,
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              const SizedBox(width: 15),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: database.orders.length,
                      itemBuilder: (c, i) {
                        final item = database.orders[i];
                        return Card(
                          color: Colors.white70,
                          child: ListTile(
                            leading:
                                Icon(Icons.assignment, color: Colors.black),
                            title: Text(
                              '#${item.id} - From: ${item.from}',
                              style: TextStyle(fontSize: 20),
                            ),
                            onTap: () => QR.to('/dashboard/orders/${item.id}'),
                          ),
                        );
                      })),
              const SizedBox(width: 15),
              Flexible(
                child: AnimatedSwitcher(
                  duration: 500.milliseconds,
                  child: routerChild,
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderDetails extends StatelessWidget {
  final order = Get.find<Database>()
      .orders[int.parse(QR.currentRoute.params['orderId'].toString()) - 1];
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 25),
            _getRow('Order Number', order.id.toString()),
            _getRow('From', order.from),
            _getRow('Created At', order.createdAt.toString()),
            const SizedBox(height: 25),
            Expanded(
                child: Card(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: order.items.length,
                        itemBuilder: (c, i) => ListTile(
                              isThreeLine: true,
                              leading: Image.network(
                                order.items[i].item.image,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(order.items[i].item.name,
                                  style: TextStyle(fontSize: 20)),
                              trailing: Text('${order.items[i].item.price}€',
                                  style: TextStyle(color: Colors.red)),
                              subtitle: Row(children: [
                                Text(
                                  'Count: ${order.items[i].count}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  // ignore: lines_longer_than_80_chars
                                  'Price: ${(order.items[i].count * order.items[i].item.price).toStringAsFixed(2)} €',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ]),
                            )))),
            const SizedBox(height: 25),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Price ',
                    style: TextStyle(color: Colors.red, fontSize: 30),
                  ),
                  Text(
                    _getTotla().toString(),
                    style: TextStyle(color: Colors.red, fontSize: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  String _getTotla() => order.items
      .map((e) => (e.count * e.item.price))
      .reduce((value, element) => value + element)
      .toStringAsFixed(2);

  Row _getRow(String lable, String value) => Row(
        children: [
          Spacer(),
          Expanded(
            flex: 1,
            child: Text(
              '$lable: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Spacer(),
        ],
      );
}
