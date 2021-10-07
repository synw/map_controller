import 'package:flutter/material.dart';

import 'index.dart';
import 'markers.dart';
import 'stateful_markers.dart';
import 'tile_layer.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (BuildContext context) => const IndexPage(),
  '/markers': (BuildContext context) => const MarkersPage(),
  '/tile_layer': (BuildContext context) => const TileLayerPage(),
  '/stateful_markers': (BuildContext context) => const StatefulMarkersPage(),
};

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map controller demo',
      routes: routes,
    );
  }
}
