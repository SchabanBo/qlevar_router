import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/page.dart';
import '../helpers/qbutton.dart';

class OverlaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: content,
            ))));
  }

  List<Widget> get content => [
        getDislogWidgets,
        getNotificationWidgets,
      ];

  Widget get getDislogWidgets => Card(
          child: Column(
        children: [
          Text('Dialogs', style: TextStyle(fontSize: 18)),
          Wrap(children: [
            QButton(
                "Show AlertDialog",
                () => QR.show(QDialog(
                    widget: (pop) => AlertDialog(title: Text('Hi Dialog'))))),
            QButton("Show Text Dialog",
                () => QDialog.text(text: Text('Simple Text')).show()),
            QButton("Wait on Result", () async {
              final result = await QR.show<String>(QDialog(
                  widget: (pop) => AlertDialog(
                        title: Text('Hi Dialog'),
                        actions: [
                          TextButton(
                              onPressed: () => pop('Yes'), child: Text('Yes')),
                          TextButton(
                              onPressed: () => pop('No'), child: Text('No'))
                        ],
                      )));
              final notificationChild = Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Dialog result is:',
                            style: TextStyle(fontSize: 18)),
                        Text(
                          result ?? 'Canceld',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
              );

              QNotification(
                      child: notificationChild,
                      position: QNotificationPosition.RightBottom)
                  .show();
            }),
          ]),
        ],
      ));

  Widget get getNotificationWidgets => Card(
          child: Column(
        children: [
          Text('Notifications', style: TextStyle(fontSize: 18)),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QButton("LeftTop",
                  () => showNotification(QNotificationPosition.LeftTop)),
              QButton("Top", () => showNotification(QNotificationPosition.Top)),
              QButton("RightTop",
                  () => showNotification(QNotificationPosition.RightTop)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              QButton("LeftCenter",
                  () => showNotification(QNotificationPosition.LeftCenter)),
              QButton("Center",
                  () => showNotification(QNotificationPosition.Center)),
              QButton("RightCenter",
                  () => showNotification(QNotificationPosition.RightCenter)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              QButton("LeftBottom",
                  () => showNotification(QNotificationPosition.LeftBottom)),
              QButton("Bottom",
                  () => showNotification(QNotificationPosition.Bottom)),
              QButton("RightBottom",
                  () => showNotification(QNotificationPosition.RightBottom)),
            ],
          ),
        ],
      ));

  void showNotification(QNotificationPosition position) {
    final notificationChild = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          FlutterLogo(size: 50.0),
          SizedBox(width: 6),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('New Notification', style: TextStyle(fontSize: 18)),
              Text(
                'Hello World',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ],
      ),
    );

    QNotification(child: notificationChild, position: position).show();
  }
}
