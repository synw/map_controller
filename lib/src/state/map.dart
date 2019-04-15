import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'markers.dart';

/// State of the map
class LiveMapState {
  /// Default constructor
  LiveMapState(
      {@required this.mapController,
      @required this.notify,
      @required this.markersState})
      : assert(mapController != null);

  /// The [MapController]
  final MapController mapController;

  /// Function to notify the changefeed
  final Function notify;

  /// Markers state
  MarkersState markersState;
  double _zoom = 1.0;
  LatLng _center = LatLng(0.0, 0.0);

  /// Zoom in one level
  Future<void> zoomIn() async {
    //print("ZOOM IN");
    double z = mapController.zoom + 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomIn);
  }

  /// Zoom out one level
  Future<void> zoomOut() async {
    //print("ZOOM OUT");
    double z = mapController.zoom - 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomOut);
  }

  /// Zoom to level
  Future<void> zoomTo(double value) async {
    //print("ZOOM TO $value");
    mapController.move(mapController.center, value);
    _zoom = value;
    notify("zoom", value, zoomOut);
  }

  /// Center the map on a [LatLng]
  Future<void> centerOnPoint(LatLng point) async {
    mapController.move(point, mapController.zoom);
    _center = point;
    notify("center", point, centerOnPoint);
  }

  /// Tell listeners that the zoom or center has changed
  ///
  /// This is used to handle the gestures
  void onPositionChanged(MapPosition posChange, bool gesture) {
    //print("Position changed: zoom ${posChange.zoom} / ${posChange.center}");
    if (posChange.zoom != _zoom) {
      _zoom = posChange.zoom;
      notify("zoom", posChange.zoom, onPositionChanged);
    }
    if (posChange.center != _center) {
      _center = posChange.center;
      notify("center", posChange.center, onPositionChanged);
    }
  }
}
