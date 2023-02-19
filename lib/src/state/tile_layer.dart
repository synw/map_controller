import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_controller_plus/src/controller.dart';
import 'package:map_controller_plus/src/models.dart';
import 'package:map_controller_plus/src/types.dart';

/// The state of the tile layer
class TileLayerState {
  /// Default contructor
  TileLayerState({
    required this.type,
    required this.notify,
    this.customTileLayer,
  }) {
    _tileLayer = _tileLayerForType(type);
  }

  /// The tile layer type
  TileLayerType type;

  /// A custom tile layer options
  TileLayer? customTileLayer;

  /// Function to notify the changefeed
  final FeedNotifyFunction notify;

  TileLayer? _tileLayer;
  TileLayer? get tileLayer => _tileLayer;

  void switchTileLayer(TileLayerType layer) {
    _tileLayer = _tileLayerForType(layer);
    notify(
      "switchTileLayer",
      layer,
      switchTileLayer,
      MapControllerChangeType.tileLayer,
    );
  }

  TileLayer? _tileLayerForType(TileLayerType layer) {
    TileLayer? tlo;
    switch (layer) {
      case TileLayerType.hike:
        tlo = TileLayer(
          urlTemplate: "https://tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
          tileProvider:
              kIsWeb ? _NonCachingNetworkTileProvider() : NetworkTileProvider(),
        );
        break;
      case TileLayerType.topography:
        tlo = TileLayer(
          urlTemplate: "http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
          tileProvider:
              kIsWeb ? _NonCachingNetworkTileProvider() : NetworkTileProvider(),
        );
        break;
      case TileLayerType.monochrome:
        tlo = TileLayer(
          urlTemplate:
              "http://www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
          tileProvider:
              kIsWeb ? _NonCachingNetworkTileProvider() : NetworkTileProvider(),
        );
        break;
      case TileLayerType.custom:
        if (customTileLayer != null) {
          tlo = customTileLayer;
        } else {
          tlo = customTileLayer;
        }
        break;
      default:
        tlo = TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
          tileProvider:
              kIsWeb ? _NonCachingNetworkTileProvider() : NetworkTileProvider(),
        );
    }
    return tlo;
  }
}

class _NonCachingNetworkTileProvider extends TileProvider {
  @override
  ImageProvider getImage(Coords<num> coords, TileLayer options) {
    return NetworkImage(getTileUrl(coords, options));
  }
}
