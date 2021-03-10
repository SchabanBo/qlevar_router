import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

void expectedPath(String path) => expect(QR.currentPath, path);
void expectedHistoryLength(int lenght) => expect(QR.history.length, lenght);
void printCurrentHistory() => print(QR.history.entries.map((e) => e.path));
