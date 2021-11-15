import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'mock_http_client.dart';

@isTest
void testFlutterMap(String description, WidgetTesterCallback callback) {
  testWidgets(description, (tester) async {
    HttpOverrides.global = MockHttpOverrides();
    await callback(tester);
  });
}
