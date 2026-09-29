import 'package:flutter/material.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Card(
          child: Text('This Page is Not Found'),
        ),
      ),
    );
  }
}
