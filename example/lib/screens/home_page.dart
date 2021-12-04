import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/descriptions.dart';
import '../helpers/page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.center,
              direction: Axis.vertical,
              children: [
                Description("Parent Page", () => QR.to("/parent"),
                    'Test simple senario for a page with children'),
                Description(
                    "Parent Page -> Child",
                    () => QR.to("/parent/child"),
                    'Navigate immediately to child of a parent page'),
                Description("Can Pop page", () => QR.to("/parent/child-6"),
                    'confirm if user want to exit'),
                Description(
                    "params /:id",
                    () => QR.to("/${Random().nextInt(1000)}"),
                    'recive custom component in the url'),
                Description(
                    "Query Params",
                    () => QR.to(
                        "/params?test=${Random().nextInt(1000)}&go=${Random().nextInt(1000)}"),
                    'Go to page with custom query params in the url'),
                Description("Test not found Page",
                    () => QR.to("/parent/no-child"), 'Go to not definded page'),
                Description(
                    "Add Remove Routes",
                    () => QR.to("/add-remove-routes"),
                    'Add and remove routes in your app in runtime'),
                Description(
                    "Nested Navigation",
                    () => QR.to("/nested"),
                    'Define a navigator in another one,'
                        ' and navigate between them easily'),
                Description("Declarative", () => QR.to("/declarative"),
                    'show page according to an object state'),
                Description("Overlays", () => QR.to("/overlays"),
                    'Show notifications and dialogs in your app'),
                Description("Code Expamles", () => QR.to("/examples"),
                    'Show qr_samples repo for more expamles'),
              ],
            )),
      ),
    );
  }
}
