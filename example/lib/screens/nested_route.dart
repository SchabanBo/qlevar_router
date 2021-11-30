import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/page.dart';
import '../helpers/qbutton.dart';
import '../routes.dart';

class NestedRoutePage extends StatelessWidget {
  final QRouter router;
  NestedRoutePage(this.router);
  @override
  Widget build(BuildContext context) {
    return PageContainer(Column(
      children: [
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              QButton("child", () => QR.to("/nested/child",pageAlreadyExistAction: PageAlreadyExistAction.BringToTop)),
              QButton("child1", () => QR.to("/nested/child-1",pageAlreadyExistAction: PageAlreadyExistAction.BringToTop)),
              QButton("child2", () => QR.to("/nested/child-2",pageAlreadyExistAction: PageAlreadyExistAction.BringToTop)),
              QButton("child3", () => QR.to("/nested/child-3",pageAlreadyExistAction: PageAlreadyExistAction.BringToTop)),
              QButton("child 4", () => QR.to("/nested/child?aa=ss",pageAlreadyExistAction: PageAlreadyExistAction.BringToTop)),
          // QButton("child", () => QR.toName(AppRoutes.nestedChild,pageAlreadyExistAction: PageAlreadyExistAction.BringToTopAndRemoveOtherSameName)),
          // QButton("child 1", () => QR.toName(AppRoutes.nestedChild1,pageAlreadyExistAction: PageAlreadyExistAction.BringToTopAndRemoveOtherSameName)),
          // QButton("child 2", () => QR.toName(AppRoutes.nestedChild2,pageAlreadyExistAction: PageAlreadyExistAction.BringToTopAndRemoveOtherSameName)),
          // QButton("child 3", () => QR.toName(AppRoutes.nestedChild3,pageAlreadyExistAction: PageAlreadyExistAction.BringToTopAndRemoveOtherSameName)),
          // QButton("child 4", () => QR.toName(AppRoutes.nestedChild,params: {
          //   "aa":"ss",
          // },pageAlreadyExistAction: PageAlreadyExistAction.BringToTopAndRemoveOtherSameName)),
          //     QButton("child", () => QR.toName(AppRoutes.nestedChild)),
          //     QButton("child 1", () => QR.toName(AppRoutes.nestedChild1)),
          //     QButton("child 2", () => QR.toName(AppRoutes.nestedChild2)),
          //     QButton("child 3", () => QR.toName(AppRoutes.nestedChild3)),
          //     QButton("child 4", () => QR.toName(AppRoutes.nestedChild,params: {
          //       "aa":"ss",
          //     })),
        ])),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Check the defrrint between showDialog() and QDialog'),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Hi'),
                              ));
                    },
                    child: Text('Normal show dialog function')),
                TextButton(
                    onPressed: () {
                      router.navigator.show(QDialog(
                          widget: (onPop) => AlertDialog(title: Text('Hi'))));
                    },
                    child: Text('Show QDialog')),
              ],
            ),
          ),
        ),
        Expanded(child: router),
      ],
    ));
  }
}

class NestedChild extends StatelessWidget {
  final String text;
  NestedChild(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text('Hi nesated $text', style: TextStyle(fontSize: 18)),
        TextButton(onPressed: QR.back, child: Text('Back')),
      ],
    ));
  }
}
