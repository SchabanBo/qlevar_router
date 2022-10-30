import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';

/// This will contain the total dependencies that are used through out all routes
/// & will be removed once if a dependency is deleted.
final HashMap<String, dynamic> _dependencies = HashMap();

/// Stores the routePath as a key & the dependencyKeys that are associated with the route
/// in a list manner as values.
///
/// These dependencyKeys will present in the [_dependencies] hash-map as a key for sure.
///
/// This hash-map will be populated when someone inserts a dependency in an route ie.,
/// If someone injected DependencyA1 & DependencyA2 at A route
/// then the key will be A & the value of A will be the list of keys that are given to
/// DependencyA1 & DependencyA2.
///
/// These will be removed if someone removes a dependency from a route
final HashMap<String, List<String>> _routesWithDependencyKeys = HashMap();

typedef AsyncDependencyBuilder<T> = Future<T> Function();

class QDependency {
  /// Gets the dependency that has been injected into the route hierarchy.
  /// If the dependency has not found under the route hierarchy then it will
  /// throw an [UnimplementedError].
  ///
  /// Example:-
  /// ```
  /// class MyPage extends StatelessWidget {
  ///   const MyPage({Key? key}) : super(key: key);
  ///
  ///   MyController get controller => QR.dependencies.get<MyController>();
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(
  ///         title: const Text('App Bar'),
  ///         centerTitle: true,
  ///       ),
  ///       body: const Center(
  ///         child: Text(
  ///           'This is MyPage',
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  /// or
  /// ```
  /// class MyPage extends StatelessWidget {
  ///   const MyPage({Key? key}) : super(key: key);
  ///
  ///   MyController get controller => QR.dependencies.get();
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(
  ///         title: const Text('App Bar'),
  ///         centerTitle: true,
  ///       ),
  ///       body: const Center(
  ///         child: Text(
  ///           'This is MyPage',
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  T get<T>({String? tag}) {
    final dependencyKey = _getDependencyKey<T>(tag: tag);
    final dependency = _dependencies[dependencyKey];
    if (dependency == null) {
      throw UnimplementedError(
          'No dependency has been injected with the key:- $dependencyKey');
    }
    return dependency;
  }

  /// Injects the passed dependency by calculating the key based on the tag provided into the hash-map.
  /// As well as insert the calculatedKey into current route dependency keys hash-map,
  /// while will be later on used to remove the dependency, if the route removed from the tree.
  ///
  /// Once dependency injected successfully we can get it later somewhere in the code
  /// that falls under the injected route hierarchy.
  ///
  /// Example:-
  /// ```
  /// final myController = QR.dependencies.inject(MyController());
  /// ```
  T inject<T>(
    T dependency, {
    String? tag,
  }) {
    final dependencyKey = _getDependencyKey<T>(tag: tag);
    QR.log('$T dependency has been created with $dependencyKey key');
    List<String>? dependencyKeysBelongToCurrRoute =
        _routesWithDependencyKeys[QR.currentPath];
    if (dependencyKeysBelongToCurrRoute == null) {
      dependencyKeysBelongToCurrRoute = [];
      _routesWithDependencyKeys[QR.currentPath] =
          dependencyKeysBelongToCurrRoute;
    }
    dependencyKeysBelongToCurrRoute.add(dependencyKey);
    if (dependency is QController) {
      dependency.onInit();
    }
    return _dependencies[dependencyKey] = dependency;
  }

  /// Works the same way as [inject] by in an async manner ie., lets suppose say
  /// if you want to inject an dependency that build in an asynchronous manner one way
  /// to accomplish is
  /// ```
  /// Future someMethod() {
  ///   final asyncDependency = await buildDependencyInAsyncManner();
  ///   QR.dependencies.inject(asyncDependency);
  /// }
  /// ```
  /// But lets suppose say you are in a situation where you cannot make a function Future
  /// & want to build dependency in async manner & inject then the this [injectAsync] method shines,
  /// also it will work for the above method too
  ///
  /// With Future parent method example:-
  /// ```
  /// Future someMethod() {
  ///   final asyncDependency = await QR.dependencies.injectAsync(() async {
  ///     return buildDependencyInAsyncManner();
  ///   });
  /// }
  /// ```
  /// or
  ///
  /// Without Future parent method example:-
  /// ```
  /// void someMethod() {
  ///   QR.dependencies.injectAsync(() async {
  ///     return buildDependencyInAsyncManner();
  ///   });
  /// }
  /// ```
  Future<T> injectAsync<T>(
    AsyncDependencyBuilder<T> builder, {
    String? tag,
    bool permanent = false,
  }) async {
    return inject<T>(await builder(), tag: tag);
  }

  /// Removes the injected dependency from the route hierarchy
  /// by calculating the key based on the tag provided.
  /// If the dependency not found in the route hierarchy then [UnimplementedError] will be thrown
  ///
  /// Example:-
  /// ```
  /// final removedMyController = QR.dependencies.remove<MyController>();
  /// ```
  /// or
  /// ```
  /// final MyController removedMyController = QR.dependencies.remove();
  /// ```
  T remove<T>(
    T dependency, {
    String? tag,
  }) {
    final dependencyKey = _getDependencyKey<T>(tag: tag);
    return removeByKey(dependencyKey);
  }

  /// Removes the injected dependency from the route hierarchy
  /// directly by the key provided. This method will be useful if we know the key
  /// of the dependency already.
  ///
  /// If the dependency not found with the provided key
  /// in the route hierarchy then [UnimplementedError] will be thrown
  ///
  /// Example:-
  /// ```
  /// final removedMyController = QR.dependencies.removeByKey<MyController>("keyToRemove");
  /// ```
  /// or
  /// ```
  /// final MyController removedMyController = QR.dependencies.removeByKey(""keyToRemove"");
  /// ```
  T removeByKey<T>(String key) {
    final removedDependency = _dependencies.remove(key);
    if (removedDependency == null) {
      throw UnimplementedError('No dependency found to remove with $key key');
    }
    if (removedDependency is QController) {
      removedDependency.onDispose();
    }
    _routesWithDependencyKeys.remove(key);
    QR.log('$removedDependency dependency with $key key has been removed');
    return removedDependency;
  }

  /// Get dependency key based on [type] & [tag]
  /// Dependency will be stored by the key this function returns.
  /// If [tag] is null then key will be the runtimeType of the dependency
  /// If [tag] is not null then it will appended to the runTimeType of the dependency
  String _getDependencyKey<T>({
    String? tag,
  }) {
    if (tag == null) {
      return T.toString();
    }
    return '$T-$tag';
  }
}

/// This class should be extended if we want to automatically inject & remove
/// the dependencies based on the way you navigate with [QR]. We should override
/// [onInit] function & inject the dependencies that we needed in that
/// which are required by that route or child routes
///
/// Example:-
/// ```
/// class MyPageDependencies extends QDependencyBinder {
///   @override
///   FutureOr<void> onInit() {
///     super.onInit();
///     QR.dependencies.inject(MyController());
///     QR.dependencies.inject(MyOtherDependency());
///     QR.dependencies.inject(OneMoreDependency());
///   }
/// }
abstract class QDependencyBinder {
  @protected
  @mustCallSuper
  FutureOr<void> onInit() {
    // At first by default set the current route dependencyKeys to empty
    _routesWithDependencyKeys[QR.currentPath] = [];
  }

  @protected
  @mustCallSuper
  FutureOr<void> onDispose(String currentPath) async {
    // Removes the dependencies one by one in reverse order
    List<String> dependencyKeysBelongToRoute =
        _routesWithDependencyKeys[currentPath]!;
    for (int i = dependencyKeysBelongToRoute.length - 1; i >= 0; --i) {
      QDependency().removeByKey(dependencyKeysBelongToRoute[i]);
    }
  }
}

/// This is wrapper on top of [QMiddleware] which will injects & remove automatically based on navigation
/// & the dependency binder that we are passing to this class must extends [QDependencyBinder].
///
/// If you are using this along with some other middlewares too then make sure the order you call it,
/// because dependencies will be injected into the memory. So if the route has some [redirectGuard]
/// then declare this [QDependencyBuilder] middleware below [redirectGuard], because if the [redirectGuard]
/// fails then there is no point of injecting dependencies into the memory we need to inject only if the
/// [redirectGuard] succeeds also make sure tho call this as the first middleware after [redirectGuard]
/// so that your dependencies will be registered & be available to all other middlewares(in-case if you need so)
///
/// Example:-
/// ```
/// QRoute(
///   name: 'my-page',
///   path: '/my-page',
///   middleware: [
///     // AuthMiddleware(),
///     QDependencyBuilder(MyPageDependencies()), // called after redirectGuard & before other middlewares
///     // OtherMiddleware(),
///     // OneMoreMiddleware()
///   ],
///   builder: () => const MyPage(),
/// ),
/// ```
class QDependencyBuilder<T extends QDependencyBinder> extends QMiddleware {
  final T dependencyBinder;

  late String currentPath;

  QDependencyBuilder(this.dependencyBinder);

  @override
  Future onEnter() async {
    currentPath = QR.currentPath;
    await dependencyBinder.onInit();
    return super.onEnter();
  }

  @override
  void onExited() {
    // This addPostFrameCallback is needed otherwise if we dispose directly then
    // we get flutter beautiful red screen errors (sometimes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dependencyBinder.onDispose(currentPath);
    });
    super.onExited();
  }
}
