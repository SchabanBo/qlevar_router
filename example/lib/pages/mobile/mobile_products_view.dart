import 'package:flutter/material.dart';

import '../../services/storage_service.dart';

class MobileProductsView extends StatelessWidget {
  final products = storageService.products;
  MobileProductsView({super.key});

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
