import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AwaitResultView extends StatefulWidget {
  const AwaitResultView({super.key});

  @override
  State<AwaitResultView> createState() => _AwaitResultViewState();
}

class _AwaitResultViewState extends State<AwaitResultView> {
  var _result = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Await Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Result: $_result',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                final result =
                    await QR.toName('GetResult', waitForResult: true);
                setState(() {
                  _result = result as int;
                });
              },
              child: const Text('Get new result'),
            ),
          ],
        ),
      ),
    );
  }
}
