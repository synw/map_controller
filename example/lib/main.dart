import 'package:flutter/material.dart';

import 'geojson.dart';
import 'index.dart';
import 'markers.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (BuildContext context) => IndexPage(),
  '/markers': (BuildContext context) => MarkersPage(),
  '/geojson': (BuildContext context) => GeoJsonPage(),
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
