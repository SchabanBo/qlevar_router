import 'package:flutter/material.dart';

class QButton extends StatelessWidget {
  final String text;
  final void Function() onPress;
  final Color textColor;
  final double fontSize;
  QButton(this.text, this.onPress,
      {this.fontSize = 18, this.textColor = Colors.black});
  @override
  Widget build(BuildContext context) => Card(
        color: Colors.white.withOpacity(0.8),
        elevation: 5,
        child: InkWell(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize, color: textColor),
            ),
          ),
        ),
      );
}
