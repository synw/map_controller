import 'package:flutter/material.dart';
import 'package:map_controller_plus/src/controller.dart';
import 'package:map_controller_plus/src/types.dart';

class _MapTileLayerNormalState extends State<MapTileLayerNormal> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
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
  const MapTileLayerNormal({super.key, required this.controller});

  /// The map controller
  final StatefulMapController controller;

  @override
  State<MapTileLayerNormal> createState() => _MapTileLayerNormalState();
}

class _MapTileLayerMonochromeState extends State<MapTileLayerMonochrome> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
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
  const MapTileLayerMonochrome({super.key, required this.controller});

  /// The map controller
  final StatefulMapController controller;

  @override
  State<MapTileLayerMonochrome> createState() => _MapTileLayerMonochromeState();
}

/// Topography tile layer
class MapTileLayerTopography extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerTopography({super.key, required this.controller});

  /// The map controller
  final StatefulMapController controller;

  @override
  State<MapTileLayerTopography> createState() => _MapTileLayerTopographyState();
}

class _MapTileLayerTopographyState extends State<MapTileLayerTopography> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      color: (_tileLayerType == TileLayerType.topography)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.photo),
      tooltip: "Topography layer",
      onPressed: () => controller.switchTileLayer(TileLayerType.topography),
    );
  }
}

/// Hike tile layer
class MapTileLayerHike extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerHike({super.key, required this.controller});

  /// The map controller
  final StatefulMapController controller;

  @override
  State<MapTileLayerHike> createState() => _MapTileLayerHikeState();
}

class _MapTileLayerHikeState extends State<MapTileLayerHike> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      color: (_tileLayerType == TileLayerType.hike)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.landscape),
      tooltip: "Hills layer",
      onPressed: () => controller.switchTileLayer(TileLayerType.hike),
    );
  }
}

class MapTileLayerCustom extends StatefulWidget {
  /// Provide a controller
  const MapTileLayerCustom({super.key, required this.controller});

  /// The map controller
  final StatefulMapController controller;

  @override
  State<MapTileLayerCustom> createState() => _MapTileLayerCustomState();
}

class _MapTileLayerCustomState extends State<MapTileLayerCustom> {
  late final StatefulMapController controller = widget.controller;
  late final TileLayerType _tileLayerType = controller.tileLayerType;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      color: (_tileLayerType == TileLayerType.custom)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.map),
      tooltip: "Custom layer",
      onPressed: () => widget.controller.switchTileLayer(TileLayerType.custom),
    );
  }
}
