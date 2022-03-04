import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/storage_service.dart';
import '../welcome/debug_tools.dart';

class ProductView extends StatelessWidget {
  // receive the store id from the previous screen
  final storeId = QR.params['id']!.asInt!;
  // receive the product id from the previous screen
  final productId = QR.params['product_id']!.asInt!;

  late final product =
      Get.find<StorageService>().stores[storeId].products[productId];

  ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product),
      ),
      body: Center(child: Icon(Icons.shopping_cart, size: 50)),
      floatingActionButton: DebugTools(),
    );
  }
}
