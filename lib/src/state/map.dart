import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models.dart';

/// State of the map
class MapState {
  /// Default constructor
  MapState({required this.mapController, required this.notify})
      : assert(mapController != null);

  /// The [MapController]
  final MapController mapController;

  /// Function to notify the changefeed
  final Function notify;

  double? _zoom = 1.0;
  LatLng? _center = LatLng(0.0, 0.0);

  /// Zoom in one level
  Future<void> zoomIn() async {
    //print("ZOOM IN");
    final z = mapController.zoom + 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomIn, MapControllerChangeType.zoom);
  }

  /// Zoom out one level
  Future<void> zoomOut() async {
    //print("ZOOM OUT");
    final z = mapController.zoom - 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomOut, MapControllerChangeType.zoom);
  }

  /// Zoom to level
  Future<void> zoomTo(double value) async {
    //print("ZOOM TO $value");
    mapController.move(mapController.center, value);
    _zoom = value;
    notify("zoom", value, zoomOut, MapControllerChangeType.zoom);
  }

  /// Center the map on a [LatLng]
  Future<void> centerOnPoint(LatLng point) async {
    mapController.move(point, mapController.zoom);
    _center = point;
    notify("center", point, centerOnPoint, MapControllerChangeType.center);
  }

  /// Tell listeners that the zoom or center has changed
  ///
  /// This is used to handle the gestures
  void onPositionChanged(MapPosition posChange, bool gesture) {
    //print("Position changed: zoom ${posChange.zoom} / ${posChange.center}");
    if (posChange.zoom != _zoom) {
      _zoom = posChange.zoom;
      notify("zoom", posChange.zoom, onPositionChanged,
          MapControllerChangeType.zoom);
    }
    if (posChange.center != _center) {
      _center = posChange.center;
      notify("center", posChange.center, onPositionChanged,
          MapControllerChangeType.center);
    }
  }
}
