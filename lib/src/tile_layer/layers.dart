import 'package:flutter/material.dart';

import '../controller.dart';
import '../types.dart';

class _MapTileLayerNormalState extends State<MapTileLayerNormal> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.normal)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.map),
      tooltip: "Normal layer",
      onPressed: () => widget.controller.switchTileLayer(TileLayerType.normal),
    );
  }
}

/// Normal tile layer
class MapTileLayerNormal extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerNormal({Key? key, required this.controller})
      : super(key: key);

  /// The map controller
  final StatefulMapController controller;

  @override
  _MapTileLayerNormalState createState() => _MapTileLayerNormalState();
}

class _MapTileLayerMonochromeState extends State<MapTileLayerMonochrome> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.monochrome)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.local_car_wash),
      tooltip: "Monochrome layer",
      onPressed: () => controller.switchTileLayer(TileLayerType.monochrome),
    );
  }
}

/// Monochrome tile layer
class MapTileLayerMonochrome extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerMonochrome({Key? key, required this.controller})
      : super(key: key);

  /// The map controller
  final StatefulMapController controller;

  @override
  _MapTileLayerMonochromeState createState() => _MapTileLayerMonochromeState();
}

class _MapTileLayerTopographyState extends State<MapTileLayerTopography> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.topography)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.photo),
      tooltip: "Topography layer",
      onPressed: () => controller.switchTileLayer(TileLayerType.topography),
    );
  }
}

/// Topography tile layer
class MapTileLayerTopography extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerTopography({Key? key, required this.controller})
      : super(key: key);

  /// The map controller
  final StatefulMapController controller;

  @override
  _MapTileLayerTopographyState createState() => _MapTileLayerTopographyState();
}

class _MapTileLayerHikeState extends State<MapTileLayerHike> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.hike)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.landscape),
      tooltip: "Hills layer",
      onPressed: () => controller.switchTileLayer(TileLayerType.hike),
    );
  }
}

/// Hike tile layer
class MapTileLayerHike extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerHike({Key? key, required this.controller})
      : super(key: key);

  /// The map controller
  final StatefulMapController controller;

  @override
  _MapTileLayerHikeState createState() => _MapTileLayerHikeState();
}

class _MapTileLayerCustomState extends State<MapTileLayerCustom> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.custom)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.map),
      tooltip: "Custom layer",
      onPressed: () => widget.controller.switchTileLayer(TileLayerType.custom),
    );
  }
}

/// Custom tile layer
class MapTileLayerCustom extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerCustom({Key? key, required this.controller})
      : super(key: key);

  /// The map controller
  final StatefulMapController controller;

  @override
  _MapTileLayerCustomState createState() => _MapTileLayerCustomState();
}
