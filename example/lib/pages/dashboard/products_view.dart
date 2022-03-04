import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/storage_service.dart';

class ProductsView extends StatelessWidget {
  final storage = Get.find<StorageService>();
  ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = QR.params['find_product'];
    if (query != null) {
      var name = '$query not found';
      final index = int.tryParse(query.toString());
      if (index != null && index >= 0 && index < storage.products.length) {
        name = storage.products[index];
      }
      return Center(
        child: Text(name),
      );
    }
    return GridView.count(
      crossAxisCount: 5,
      children: storage.products
          .map(
            (e) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                      '${storage.products.indexOf(e)} - ${e.toUpperCase()}'),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
