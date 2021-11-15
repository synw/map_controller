import 'package:flutter_test/flutter_test.dart';

import '../utils/custom_tests.dart';
import '../utils/test_app.dart';

void main() {
  group('StatefulMapController', () {
    testFlutterMap(
      'mapController is the same instance as passed to constructor',
      (tester, mapController, statefulMapController) async {
        expect(statefulMapController.mapController, mapController);
      },
    );

    testFlutterMap(
      'zoom',
      (tester, mapController, statefulMapController) async {
        await tester.pumpWidget(
          TestApp(mapController: statefulMapController.mapController),
        );
        expect(statefulMapController.zoom, 13.0);
      },
    );

    testFlutterMap(
      'zoomIn',
      (tester, mapController, statefulMapController) async {
        await tester.pumpWidget(
          TestApp(mapController: statefulMapController.mapController),
        );
        expect(statefulMapController.zoom, 13.0);
        statefulMapController.zoomIn();
        expect(statefulMapController.zoom, 14.0);
      },
    );

    testFlutterMap(
      'zoomOut',
      (tester, mapController, statefulMapController) async {
        await tester.pumpWidget(
          TestApp(mapController: statefulMapController.mapController),
        );
        expect(statefulMapController.zoom, 13.0);
        statefulMapController.zoomOut();
        expect(statefulMapController.zoom, 12.0);
      },
    );
  });
}
