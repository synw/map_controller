import 'dart:io';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_controller/map_controller.dart';
import 'package:meta/meta.dart';

import 'mock_http_client.dart';

typedef FlutterMapTesterCallback = Future<void> Function(
  WidgetTester widgetTester,
  MapController mapController,
  StatefulMapController statefulMapController,
);

/// Custom test to expose a [MapController] and [StatefulMapController], it also
/// overrides the global [HttpOverrides].
@isTest
void testFlutterMap(String description, FlutterMapTesterCallback callback) {
  testWidgets(description, (tester) async {
    final mapController = MapController();
    final statefulController = StatefulMapController(
      mapController: mapController,
    );
    HttpOverrides.global = MockHttpOverrides();
    await callback(tester, mapController, statefulController);
  });
}
