import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: QRouteInformationParser(),
        routerDelegate:
            QRouterDelegate(AppRoutes().routes(), initPath: '/games'),
      );
}

class AppRoutes {
  List<QRoute> routes() => <QRoute>[
        QRoute(path: '/games', builder: () => GamesPage(), children: [
          QRoute(path: '/:gameId', builder: () => GameRoom()),
        ]),
      ];
}

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Linking', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              columnPlaceHolder,
              const SizedBox(width: 10),
              columnPlaceHolder,
              const SizedBox(width: 10),
              columnPlaceHolder,
            ],
          ),
        ));
  }

  Widget get columnPlaceHolder => Flexible(
        child: Column(
          children: [
            const SizedBox(height: 10),
            getPlaceHolder(flex: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Lorem ipsum dolor sit amet',
                    style: TextStyle(fontSize: 22)),
              ),
            ),
            infoPlaceHolder,
            Spacer(),
          ],
        ),
      );

  Widget get infoPlaceHolder => Flexible(
        child: Row(
          children: [
            getPlaceHolder(),
            linesPlaceHolder,
          ],
        ),
      );

  Widget get linesPlaceHolder => Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getPlaceHolder(),
              Spacer(flex: 2),
              getPlaceHolder(),
              Spacer(flex: 2),
              getPlaceHolder(),
              Spacer(flex: 2),
              getPlaceHolder(),
            ],
          ),
        ),
      );

  Widget getPlaceHolder({int flex = 1}) => Flexible(
      flex: flex,
      child: InkWell(
          onTap: () => QR.to('/games/${Random().nextInt(1000)}'),
          child: Container(color: Colors.grey.shade400)));
}

class GameRoom extends StatelessWidget {
  final gameId = QR.params['gameId']!.asInt!;
  @override
  Widget build(BuildContext context) {
    final url = '${Uri.base}/${'$gameId'}';
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Room $gameId', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey.shade100,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          width: size.width * 0.7,
          height: size.height * 0.7,
          color: Colors.grey.shade400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Game Room with id $gameId', style: TextStyle(fontSize: 25)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 25),
                  Text(url),
                  const SizedBox(width: 25),
                  ElevatedButton(
                      onPressed: () =>
                          Clipboard.setData(ClipboardData(text: url)),
                      child: Text('Copy Path')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
