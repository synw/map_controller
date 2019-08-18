import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import '../models.dart';

/// The state of the markers on the map
class MarkersState {
  /// Provide a [MapController]
  MarkersState({@required this.mapController, @required this.notify})
      : assert(mapController != null);

  /// The Flutter Map controller
  final MapController mapController;

  /// The notification function
  final Function notify;

  var _markers = <Marker>[];
  final Map<String, Marker> _namedMarkers = {};

  /// The markers present on the map
  List<Marker> get markers => _markers;

  /// The markers present on the map and their names
  Map<String, Marker> get namedMarkers => _namedMarkers;

  /// Add a marker on the map
  Future<void> addMarker({Marker marker, @required String name}) async {
    if (marker == null) throw ArgumentError("marker must not be null");
    if (name == null) throw ArgumentError("name must not be null");
    //print("STATE ADD MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    try {
      _namedMarkers[name] = marker;
    } catch (e) {
      throw ("Can not add marker: $e");
    }
    //print("STATE MARKERS AFTER ADD: $_namedMarkers");
    try {
      _buildMarkers();
    } catch (e) {
      throw ("Can not build for add marker: $e");
    }
    notify(
        "updateMarkers", _markers, addMarker, MapControllerChangeType.markers);
  }

  /// Remove a marker from the map
  Future<void> removeMarker({@required String name}) async {
    if (name == null) throw ArgumentError("name must not be null");
    //if (name != "livemarker") {
    //print("STATE REMOVE MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    //}
    try {
      var res = _namedMarkers.remove(name);
      if (res == null) {
        throw ("Marker $name not found in map");
      }
    } catch (e) {
      throw ("Can not remove marker: $e");
    }
    try {
      _buildMarkers();
    } catch (e) {
      throw ("Can not build for remove marker: $e");
    }
    //print("STATE MARKERS AFTER REMOVE: $_namedMarkers");
    notify("updateMarkers", _markers, removeMarker,
        MapControllerChangeType.markers);
  }

  /// Add multiple markers on the map
  Future<void> addMarkers({@required Map<String, Marker> markers}) async {
    if (markers == null) {
      throw (ArgumentError.notNull("markers must not be null"));
    }
    if (markers == null) throw ArgumentError("markers must not be null");
    try {
      markers.forEach((k, v) {
        _namedMarkers[k] = v;
      });
    } catch (e) {
      throw ("Can not add markers: $e");
    }
    _buildMarkers();
    notify(
        "updateMarkers", _markers, addMarkers, MapControllerChangeType.markers);
  }

  /// Remove multiple markers from the map
  Future<void> removeMarkers({@required List<String> names}) async {
    if (names == null) throw (ArgumentError.notNull("names must not be null"));
    names.forEach((name) {
      _namedMarkers.remove(name);
    });
    _buildMarkers();
    notify("updateMarkers", _markers, removeMarkers,
        MapControllerChangeType.markers);
  }

  /// Export all markers to a [GeoJsonFeature] with geometry
  /// type [GeoJsonMultiPoint]
  GeoJsonFeature toGeoJsonFeatures() {
    final multiPoint = GeoJsonMultiPoint();
    var geoPoints = <GeoPoint>[];
    for (final k in namedMarkers.keys) {
      final m = namedMarkers[k];
      geoPoints.add(GeoPoint(
        latitude: m.point.latitude,
        longitude: m.point.longitude,
      ));
    }
    multiPoint.name = "map_markers";
    multiPoint.geoSerie =
        GeoSerie.fromNameAndType(name: multiPoint.name, typeStr: "group");
    multiPoint.geoSerie.geoPoints = geoPoints;
    final feature = GeoJsonFeature<GeoJsonMultiPoint>();
    feature.type = GeoJsonFeatureType.multipoint;
    feature.properties = <String, dynamic>{"name": multiPoint.name};
    feature.geometry = multiPoint;
    return feature;
  }

  void _buildMarkers() {
    var listMarkers = <Marker>[];
    //print("BEFORE BUILD MARKERS");
    //_printMarkers();
    for (var k in _namedMarkers.keys) {
      //print("Adding $k: ${_namedMarkers[k]}");
      listMarkers.add(_namedMarkers[k]);
    }
    _markers = listMarkers;
    //print("AFTER BUILD MARKERS");
    //_printMarkers();
  }

  /*void _printMarkers() {
    for (var k in _namedMarkers.keys) {
      print("NAMED MARKER $k: ${_namedMarkers[k]}");
    }
  }*/
}
