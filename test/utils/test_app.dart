import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TestApp extends StatefulWidget {
  final MapController? mapController;

  /// Test widget to show a map with a marker with a zoom level of `13.0`.
  const TestApp({Key? key, this.mapController}) : super(key: key);

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
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
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
