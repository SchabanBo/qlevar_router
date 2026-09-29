import 'package:flutter/material.dart';

class ChildView extends StatelessWidget {
  final String name;
  const ChildView(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: const Center(
        child: Icon(Icons.child_friendly, size: 100, color: Colors.green),
      ),
    );
  }
}
