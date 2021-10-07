import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../controller.dart';
import '../models.dart';

/// State of the map
class MapState {
  /// Default constructor
  MapState({required this.mapController, required this.notify});

  /// The [MapController]
  final MapController mapController;

  /// Function to notify the changefeed
  final FeedNotifyFunction notify;

  double? _zoom = 1.0;
  LatLng? _center = LatLng(0.0, 0.0);

  /// Zoom in one level
  void zoomIn() {
    final z = mapController.zoom + 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomIn, MapControllerChangeType.zoom);
  }

  /// Zoom out one level
  void zoomOut() {
    final z = mapController.zoom - 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomOut, MapControllerChangeType.zoom);
  }

  /// Zoom to level
  void zoomTo(double value) async {
    mapController.move(mapController.center, value);
    _zoom = value;
    notify("zoom", value, zoomOut, MapControllerChangeType.zoom);
  }

  /// Center the map on a [LatLng]
  void centerOnPoint(LatLng point) {
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
