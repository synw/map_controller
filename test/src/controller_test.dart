import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_controller/map_controller.dart';

import '../utils/custom_tests.dart';
import '../utils/test_app.dart';

void main() {
  group('StatefulMapController', () {
    final mapController = MapController();
    final statefulController = StatefulMapController(
      mapController: mapController,
    );

    testFlutterMap(
      'mapController is the same instance as passed to constructor',
      (tester) async {
        expect(statefulController.mapController, mapController);
      },
    );

    testFlutterMap('zoom', (tester) async {
      await tester.pumpWidget(
        TestApp(mapController: statefulController.mapController),
      );
      expect(statefulController.zoom, 13.0);
    });
  });
}
