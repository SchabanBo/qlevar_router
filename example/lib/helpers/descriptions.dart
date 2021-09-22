import 'package:flutter/material.dart';

import 'qbutton.dart';

class Description extends StatefulWidget {
  final String text;
  final String descriptions;
  final void Function() onPress;

  const Description(this.text, this.onPress, [this.descriptions = '', Key? key])
      : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (s) {
        if (widget.descriptions.isEmpty) return;
        setState(() {
          open = true;
        });
      },
      onExit: (e) {
        if (widget.descriptions.isEmpty) return;
        setState(() {
          open = false;
        });
      },
      child: Row(
        children: [
          QButton(widget.text, widget.onPress),
          AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: open
                  ? Text(
                      widget.descriptions,
                      style: TextStyle(fontSize: 18),
                    )
                  : SizedBox())
        ],
      ),
    );
  }
}
