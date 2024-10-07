import 'package:flutter/material.dart';

class NodeWidget extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  const NodeWidget({
    required this.name,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 35,
            color: Colors.indigo,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
