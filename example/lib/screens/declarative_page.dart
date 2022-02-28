import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/page.dart';

class DeclarativePage extends StatefulWidget {
  final QKey dKey;
  DeclarativePage(this.dKey);
  @override
  _DeclarativePageState createState() => _DeclarativePageState();
}

class _DeclarativePageState extends State<DeclarativePage> {
  final state = _Info();
  @override
  Widget build(BuildContext context) => PageContainer(QDeclarative(
      routeKey: widget.dKey,
      builder: () => [
            QDRoute(
              name: 'Hungry',
              builder: () => getQuestion(
                  (v) => state.loveCoffee = v, 'Do you love Coffee?'),
              when: () => state.loveCoffee == null,
              // when this route pop, if you want to get out of the declarative
              // router give false as result so the router know that this
              // function didn't processed the pop and process it
              onPop: () => false,
            ),
            QDRoute(
                name: 'Burger',
                builder: () => getQuestion(
                    (v) => state.loveBurger = v, 'Do you love burger?'),
                onPop: () => state.loveCoffee = null,
                when: () => state.loveBurger == null,
                pageType: QSlidePage(
                    curve: Curves.easeInOutCubic,
                    offset: Offset(-1, 0),
                    transitionDurationMilliseconds: 500)),
            QDRoute(
                name: 'Pizza',
                builder: () => getQuestion(
                    (v) => state.lovePizza = v, 'Do you love Pizza?'),
                onPop: () => state.loveBurger = null,
                when: () => state.lovePizza == null,
                pageType: QSlidePage(offset: Offset(-1, 1))),
            QDRoute(
                name: 'Result',
                builder: result,
                onPop: () => state.lovePizza = null,
                when: () => state.allSet)
          ]));

  Widget getQuestion(void Function(bool) value, String text) => Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        back,
        SizedBox(height: 50),
        Text(text, style: TextStyle(fontSize: 18)),
        SizedBox(height: 25),
        yesNo(value),
      ]));

  Widget yesNo(void Function(bool) value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                value(true);
                setState(() {});
              },
              child: Text('Yes', style: TextStyle(fontSize: 18))),
          ElevatedButton(
              onPressed: () {
                value(false);
                setState(() {});
              },
              child: Text('No', style: TextStyle(fontSize: 18))),
        ],
      );

  Widget result() => Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          back,
          SizedBox(height: 25),
          Text('Your answers: $state'),
          SizedBox(height: 50),
          Text(getResult(), style: TextStyle(fontSize: 25)),
          Divider(),
          ElevatedButton(
              onPressed: () {
                state.loveCoffee = null;
                state.loveBurger = null;
                state.lovePizza = null;
                setState(() {});
              },
              child: Text('Reset')),
        ],
      ));

  Widget back = ElevatedButton(onPressed: QR.back, child: Text('Back'));

  String getResult() {
    if (state.loveCoffee == true && state.loveBurger == false) {
      // ignore: lines_longer_than_80_chars
      return "Lets go to burger king, you can order Coffee and will get a burger :)";
    }
    if (state.loveCoffee == true) {
      return "Lets go to burger king, you can order coffee :)";
    }
    if (state.loveBurger == true) {
      return "Lets go to burger king :)";
    }
    return " I want burger, lets go to burger king :D";
  }
}

class _Info {
  bool? loveCoffee;
  bool? loveBurger;
  bool? lovePizza;

  bool get allSet =>
      loveBurger != null && loveCoffee != null && lovePizza != null;

  @override
  String toString() =>
      'loveCoffee: $loveCoffee, loveBurger: $loveBurger, lovePizza: $lovePizza';
}
