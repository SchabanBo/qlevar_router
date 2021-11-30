import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/descriptions.dart';
import '../helpers/page.dart';

class ExamplesPage extends StatelessWidget {
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
              // ignore: lines_longer_than_80_chars
              children: children,
            )),
      ),
    );
  }

  List<Widget> get children => [
        Description(
            "Repo",
            () => launch('https://github.com/SchabanBo/qr_samples'),
            'Show the sample repo on github'),
        Description(
            "Dashboard",
            () => launch(
                'https://github.com/SchabanBo/qr_samples/blob/main/lib/common_cases/dashboard.dart'),
            'Show dashboard example'),
        Description(
            "Bottom Navigation bar",
            () => launch(
                'https://github.com/SchabanBo/qr_samples/blob/main/lib/common_cases/bottom_nav_bar.dart'),
            'Example of bottom navigation bar with QR'),
        Description(
            "Can pop",
            () => launch(
                'https://github.com/SchabanBo/qr_samples/blob/main/lib/examples/can_pop.dart'),
            'Example canceling the navigation with back button'),
        Description(
            "Nested in Nested",
            () => launch(
                'https://github.com/SchabanBo/qr_samples/blob/main/lib/special_cases/nested_in_nested.dart'),
            'Complex Example of using multi nested navigations in each other'),
      ];
}
