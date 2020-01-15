import 'package:flutter/material.dart';

import 'geojson.dart';
import 'index.dart';
import 'markers.dart';
import 'stateful_markers.dart';
import 'tile_layer.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (BuildContext context) => IndexPage(),
  '/markers': (BuildContext context) => MarkersPage(),
  '/geojson': (BuildContext context) => GeoJsonPage(),
  '/tile_layer': (BuildContext context) => TileLayerPage(),
  '/stateful_markers': (BuildContext context) => StatefulMarkersPage(),
};

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map controller demo',
      routes: routes,
    );
  }
}
