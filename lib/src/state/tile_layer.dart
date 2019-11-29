import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models.dart';
import '../types.dart';

/// The state of the tile layer
class TileLayerState {
  /// Default contructor
  TileLayerState(
      {@required this.type, @required this.notify, this.customTileLayer}) {
    _tileLayer = _tileLayerForType(type);
  }

  /// The tile layer type
  TileLayerType type;

  /// A custom tile layer options
  TileLayerOptions customTileLayer;

  /// Function to notify the changefeed
  final Function notify;

  TileLayerOptions _tileLayer;

  TileLayerOptions get tileLayer => _tileLayer;

  void switchTileLayer(TileLayerType layer) {
    _tileLayer = _tileLayerForType(layer);
    notify("switchTileLayer", layer, switchTileLayer,
        MapControllerChangeType.tileLayer);
  }

  TileLayerOptions _tileLayerForType(TileLayerType layer) {
    TileLayerOptions tlo;
    switch (layer) {
      case TileLayerType.hike:
        tlo = TileLayerOptions(
            urlTemplate: "https://tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']);
        break;
      case TileLayerType.topography:
        tlo = TileLayerOptions(
            urlTemplate: "http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']);
        break;
      case TileLayerType.monochrome:
        tlo = TileLayerOptions(
            urlTemplate:
                "http://www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']);
        break;
      case TileLayerType.custom:
        if (customTileLayer != null) {
          tlo = customTileLayer;
        } else {
          tlo = TileLayerOptions(
              urlTemplate:
                  "http://www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']);
        }
        break;
      default:
        tlo = TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']);
    }
    return tlo;
  }
}
