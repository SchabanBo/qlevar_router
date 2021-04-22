import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/page.dart';

class DeclarativePage extends StatefulWidget {
  final QKey dkey;
  DeclarativePage(this.dkey);
  @override
  _DeclarativePageState createState() => _DeclarativePageState();
}

class _DeclarativePageState extends State<DeclarativePage> {
  final state = _Info();
  @override
  Widget build(BuildContext context) => PageContainer(QDeclarative(
      routeKey: widget.dkey,
      builder: () => [
            QDRoute(
                name: 'Hungry',
                builder: () =>
                    getQuestion((v) => state.isHungry = v, 'Are you hungry?'),
                when: () {
                  print(state.isHungry);
                  return state.isHungry == null;
                }),
            QDRoute(
                name: 'Burger',
                builder: () => getQuestion(
                    (v) => state.loveBuger = v, 'Do you love burger?'),
                onPop: () => state.isHungry = null,
                pageType: QSlidePage(
                    curve: Curves.easeInOutCubic,
                    offset: Offset(-1, 0),
                    transitionDurationmilliseconds: 500),
                when: () => state.isHungry == true && state.loveBuger == null),
            QDRoute(
                name: 'Pizza',
                builder: () => getQuestion(
                    (v) => state.lovePizza = v, 'Do you love Pizza?'),
                onPop: () => state.loveBuger = null,
                pageType: QSlidePage(
                    curve: Curves.easeInExpo,
                    offset: Offset(0, 1),
                    transitionDurationmilliseconds: 600),
                when: () =>
                    state.isHungry == true &&
                    state.loveBuger != null &&
                    state.lovePizza == null),
            QDRoute(
                name: 'Result',
                builder: result,
                onPop: () => state.lovePizza = null,
                when: () =>
                    state.isHungry == false ||
                    (state.isHungry == true &&
                        state.loveBuger != null &&
                        state.lovePizza != null))
          ]));

  Widget getQuestion(void Function(bool) value, String text) =>
      _DeclerativeChild(
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              child: Text('No', style: TextStyle(fontSize: 18)))
        ],
      );

  Widget result() => _DeclerativeChild(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(getResult(), style: TextStyle(fontSize: 25)),
          Divider(),
          ElevatedButton(
              onPressed: () {
                state.isHungry = null;
                state.loveBuger = null;
                state.lovePizza = null;
                setState(() {});
              },
              child: Text('Reset')),
        ],
      ));

  String getResult() {
    print(state.isHungry);
    if (state.isHungry == false) {
      return "Lets go to starbucks :(";
    }
    if (state.loveBuger == true) {
      return "Lets go to burger king :)";
    }
    return " I want burger, lets go to burger king :D";
  }
}

class _Info {
  bool? isHungry;
  bool? loveBuger;
  bool? lovePizza;
}

class _DeclerativeChild extends StatelessWidget {
  final Widget child;
  _DeclerativeChild(this.child);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Declerative Router'),
        centerTitle: true,
      ),
      body: Container(
        child: child,
      ),
    );
  }
}
