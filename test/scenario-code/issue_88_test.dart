import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';
import '../test_widgets/test_widgets.dart';

void main() {
  final routes = [
    QRoute(
      name: 'sign-in',
      path: '/sign-in',
      builder: () => const SignInPage(),
    ),
    QRoute(
      name: 'sign-up',
      path: '/sign-up',
      builder: () => const SignUpPage(),
    ),
    QRoute(
      name: 'forgot-password',
      path: '/forgot-password',
      builder: () => const ForgotPassword(),
    ),
    QRoute.withChild(
      name: 'dashboard',
      path: '/dashboard',
      initRoute: '/home',
      children: [
        QRoute(
          name: 'home',
          path: '/home',
          builder: () => ElevatedButton(
            onPressed: () => QR.navigator.replaceAllWithName('sign-in'),
            child: const Text('Logout'),
          ),
        )
      ],
      builderChild: (router) => Dashboard(router: router),
    ),
  ];
  testWidgets('Test issue 88 case 1', (widgetTester) async {
    QR.reset();
    await widgetTester.pumpWidget(AppWrapper(routes, initPath: '/sign-in'));
    await widgetTester.pumpAndSettle();
    expectedPath('/sign-in');
    await widgetTester.tap(find.text('Login'));

    await widgetTester.pumpAndSettle();
    expectedPath('/dashboard/home');
    await widgetTester.tap(find.text('Logout'));
    await widgetTester.pumpAndSettle();
    expectedPath('/sign-in');
    await widgetTester.tap(find.text('Sign-Up'));
    await widgetTester.pumpAndSettle();
    expectedPath('/sign-up');
  });

  testWidgets('Test issue 88 case 1', (widgetTester) async {
    QR.reset();
    await widgetTester.pumpWidget(AppWrapper(routes, initPath: '/sign-in'));
    await widgetTester.pumpAndSettle();
    expectedPath('/sign-in');
    await widgetTester.tap(find.text('Login'));
    await widgetTester.pumpAndSettle();
    expectedPath('/dashboard/home');
    await widgetTester.tap(find.text('Logout'));
    await widgetTester.pumpAndSettle();
    expectedPath('/sign-in');
    await widgetTester.tap(find.text('Forgot-Password'));
    await widgetTester.pumpAndSettle();
    expectedPath('/forgot-password');
    await widgetTester.tap(find.text('Go back'));
    await widgetTester.pumpAndSettle();
    expectedPath('/sign-in');
  });
}

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const TextField(),
          ElevatedButton(
            onPressed: () => QR.toName('forgot-password'),
            child: const Text('Forgot-Password'),
          ),
          ElevatedButton(
            onPressed: () => QR.navigator.replaceLastName('sign-up'),
            child: const Text('Sign-Up'),
          ),
          ElevatedButton(
            onPressed: () => QR.navigator.replaceLastName('dashboard'),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const TextField(),
          ElevatedButton(
            onPressed: () => QR.navigator.replaceLastName('sign-in'),
            child: const Text('Sign-In'),
          ),
          ElevatedButton(
            onPressed: () => QR.navigator.replaceLastName('dashboard'),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Forgot password'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () => QR.back(),
              child: const Text('Go back'),
            ),
          ],
        ),
      );
}

class Dashboard extends StatelessWidget {
  final QRouter router;
  const Dashboard({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
        ),
        body: router,
      );
}
