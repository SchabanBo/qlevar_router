import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/storage_service.dart';

class MobileStoresView extends StatelessWidget {
  final stores = Get.find<StorageService>().stores;
  MobileStoresView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: stores.map((store) {
        return ListTile(
          title: Text(store.name),
        );
      }).toList(),
    );
  }
}
