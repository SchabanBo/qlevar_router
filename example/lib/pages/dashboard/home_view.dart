import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/storage_service.dart';

class HomeView extends StatelessWidget {
  final storage = Get.find<StorageService>();
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        children: [
          Text('Home', style: textTheme.displaySmall),
          const SizedBox(height: 16),
          Text(
            'Stores: ${storage.stores.length}',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Products: ${storage.products.length}',
            style: textTheme.titleLarge,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Type product index to show (Press enter)',
            ),
            onSubmitted: (value) {
              final index = int.tryParse(value);
              if (index != null) {
                QR.to('dashboard/products?find_product=$index');
              }
            },
          ),
        ],
      ),
    );
  }
}
