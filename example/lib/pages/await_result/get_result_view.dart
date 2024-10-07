import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class GetResultView extends StatelessWidget {
  const GetResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get result'),
      ),
      body: ListView(
        children: List.generate(15, (index) {
          return ListTile(
            title: Text('Item $index'),
            onTap: () {
              QR.back(index);
            },
          );
        }),
      ),
    );
  }
}
