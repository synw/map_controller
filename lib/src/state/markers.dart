import 'package:flutter_map/flutter_map.dart';

import '../controller.dart';
import '../exceptions.dart';
import '../models.dart';

/// The state of the markers on the map
class MarkersState {
  /// Provide a [MapController]
  MarkersState({required this.mapController, required this.notify});

  /// The Flutter Map controller
  final MapController mapController;

  /// The notification function
  final FeedNotifyFunction notify;

  var _markers = <Marker>[];
  final Map<String, Marker> _namedMarkers = {};

  /// The markers present on the map
  List<Marker> get markers => _markers;

  /// The markers present on the map and their names
  Map<String, Marker> get namedMarkers => _namedMarkers;

  /// Add a marker on the map
  Future<void> addMarker({required String name, required Marker marker}) async {
    //print("STATE ADD MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    try {
      //_buildMarkers();
      final markerAt = _markerAt(_namedMarkers[name], name);
      if (markerAt == null) {
        _markers.add(marker);
      } else {
        _markers[markerAt] = marker;
      }
    } catch (e) {
      throw MarkerException("Can not build marker $name for add: $e");
    }
    notify("updateMarkers", marker, addMarker, MapControllerChangeType.markers);
    try {
      _namedMarkers[name] = marker;
    } catch (e) {
      throw MarkerException("Can not add marker: $e");
    }
    //print("STATE MARKERS AFTER ADD: $_namedMarkers");
  }

  /// Remove a marker from the map
  Future<void> removeMarker({required String name}) async {
    //if (name != "livemarker") {
    //print("STATE REMOVE MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    //}
    try {
      //_buildMarkers();
      final removeAt = _markerAt(_namedMarkers[name], name);
      if (removeAt != null) {
        _markers.removeAt(removeAt);
      } else {
        throw MarkerException("Can not find marker $name for removal");
      }
    } catch (e) {
      throw MarkerException("Can not build for remove marker: $e");
    }
    notify(
        "updateMarkers", name, removeMarker, MapControllerChangeType.markers);
    try {
      final res = _namedMarkers.remove(name);
      if (res == null) {
        throw MarkerException("Marker $name not found in map");
      }
    } catch (e) {
      throw MarkerException("Can not remove marker: $e");
    }
    print("STATE MARKERS AFTER REMOVE: $_namedMarkers");
  }

  int? _markerAt(Marker? marker, String name) {
    int? removeAt;
    if (!_namedMarkers.containsKey(name)) {
      return removeAt;
    }
    var i = 0;
    for (final m in _markers) {
      if (m.point == _namedMarkers[name]!.point) {
        removeAt = i;
        break;
      }
      ++i;
    }
    return removeAt;
  }

  /// Add multiple markers on the map
  Future<void> addMarkers({required Map<String, Marker> markers}) async {
    try {
      markers.forEach((k, v) {
        _namedMarkers[k] = v;
      });
    } catch (e) {
      throw MarkerException("Can not add markers: $e");
    }
    _buildMarkers();
    notify(
        "updateMarkers", markers, addMarkers, MapControllerChangeType.markers);
  }

  /// Remove multiple markers from the map
  Future<void> removeMarkers({required List<String> names}) async {
    names.forEach(_namedMarkers.remove);
    _buildMarkers();
    notify(
        "updateMarkers", names, removeMarkers, MapControllerChangeType.markers);
  }

  /// Fit a marker on map
  void fitOne(String name) {
    final bounds = LatLngBounds()..extend(namedMarkers[name]!.point);
    mapController.fitBounds(bounds);
  }

  /// Fit all markers on map
  void fitAll() {
    final bounds = LatLngBounds();
    for (final m in namedMarkers.keys) {
      bounds.extend(namedMarkers[m]!.point);
    }
    mapController.fitBounds(bounds);
  }

  void _buildMarkers() {
    _markers = _namedMarkers.values.toList();
    //print("AFTER BUILD MARKERS");
    //_printMarkers();
  }

  /*void _printMarkers() {
    for (var k in _namedMarkers.keys) {
      print("NAMED MARKER $k: ${_namedMarkers[k]}");
    }
  }*/
}
