import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_controller/map_controller.dart';

import '../controller.dart';
import '../types.dart';

class _TileLayersBarState extends State<TileLayersBar> {
  _TileLayersBarState({required this.controller})
      : assert(controller != null),
        _tileLayerType = controller.tileLayerType;

  final StatefulMapController controller;

  TileLayerType _tileLayerType;
  late StreamSubscription<StatefulMapControllerStateChange> _sub;

  @override
  void initState() {
    _sub = controller.changeFeed.listen((change) {
      if (change.type == MapControllerChangeType.tileLayer) {
        setState(() => _tileLayerType = change.value as TileLayerType);
      }
    });
    super.initState();
  }

  Widget _buildLayers() {
    return Column(children: <Widget>[
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.normal)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.map),
        tooltip: "Normal layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.normal),
      ),
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.monochrome)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.local_car_wash),
        tooltip: "Monochrome layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.monochrome),
      ),
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.topography)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.photo),
        tooltip: "Topography layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.topography),
      ),
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.hike)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.landscape),
        tooltip: "Hills layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.hike),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) => _buildLayers();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// The tile layers bar
class TileLayersBar extends StatefulWidget {
  /// Provide a controller
  const TileLayersBar({required this.controller});

  /// The map controller
  final StatefulMapController controller;

  @override
  _TileLayersBarState createState() =>
      _TileLayersBarState(controller: controller);
}
