import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TestApp extends StatefulWidget {
  /// Test widget to show a map with a marker with a zoom level of `13.0`.
  const TestApp({
    super.key,
    this.mapController,
  });

  final MapController? mapController;

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            center: LatLng(45.5231, -122.6765),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80,
                  height: 80,
                  point: LatLng(45.5231, -122.6765),
                  builder: (ctx) => const FlutterLogo(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
