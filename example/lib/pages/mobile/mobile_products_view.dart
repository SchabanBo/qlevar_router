import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/storage_service.dart';

class MobileProductsView extends StatelessWidget {
  final products = Get.find<StorageService>().products;
  MobileProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: products.map((product) {
        return ListTile(
          title: Text(product),
        );
      }).toList(),
    );
  }
}
