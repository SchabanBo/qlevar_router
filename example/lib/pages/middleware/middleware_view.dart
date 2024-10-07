import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../services/storage_service.dart';

class MiddlewareView extends StatelessWidget {
  const MiddlewareView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final style = Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(color: Colors.indigo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Middleware Features'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => QR.to('/parent/child-1'),
                      child: Text('Child-1', style: style),
                    ),
                    const Text('Nothing special'),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => QR.to('/parent/child-2'),
                      child: Text('Child-2', style: style),
                    ),
                    ObxValue<RxBool>(
                        (v) => Checkbox(
                              value: v.value,
                              onChanged: (e) {
                                storage.canNavigateToChild = e ?? true;
                                v(e);
                              },
                            ),
                        storage.canNavigateToChild.obs),
                    const Text(
                        // ignore: lines_longer_than_80_chars,
                        'If this is check, this page will redirect to child-1 and will never be opened, this uses redirect by path'),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => QR.to('/parent/child-3'),
                      child: Text('Child-3', style: style),
                    ),
                    const Text(
                        // ignore: lines_longer_than_80_chars,
                        'This page will redirect to store with index 2 and could never be opened, this uses redirect by name'),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => QR.to('/parent/child-4'),
                      child: Text('Child-4', style: style),
                    ),
                    const Text('This child will test the can pop feature'),
                    const Text(
                        'This can cancel the user navigation back request'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
