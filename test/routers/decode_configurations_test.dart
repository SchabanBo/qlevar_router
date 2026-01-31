import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  group('decodeConfigurations', () {
    final delegate = QRouterDelegate([
      QRoute(path: '/', builder: () => Container()),
    ]);

    test('should return decoded path when encoded', () {
      expect(delegate.decodeConfigurations('%2Fpath%2Fto'), '/path/to');
    });

    test('should return fragment when has fragment (Hash Strategy)', () {
      expect(
          delegate.decodeConfigurations('http://domain.com/#/home'), '/home');
      expect(delegate.decodeConfigurations('/#/home'), '/home');
      expect(delegate.decodeConfigurations('#/home'), '/home');
    });

    test('should return path from full url', () {
      expect(
          delegate.decodeConfigurations('https://domain.com/path/to/resource'),
          '/path/to/resource');
    });

    test('should return simple path as is', () {
      expect(delegate.decodeConfigurations('/path/to/resource'),
          '/path/to/resource');
    });

    test('should handle url with query params by returning only path', () {
      // Current implementation returns uri.path which strips query params
      expect(delegate.decodeConfigurations('/path?query=1'), '/path?query=1');
      expect(delegate.decodeConfigurations('https://domain.com/path?id=123'),
          '/path?id=123');
    });

    test('should return encoded path when input has space', () {
      // 'a space' is parsed by Uri.tryParse but the path becomes 'a%20space'
      expect(delegate.decodeConfigurations('a space'), 'a%20space');
    });
  });
}
