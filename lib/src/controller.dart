import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'models.dart';
import 'state/map.dart';
import 'state/markers.dart';
import 'state/lines.dart';
import 'state/polygons.dart';

/// The map controller
class StatefulMapController {
  /// Provide a Flutter map [MapController]
  StatefulMapController({@required this.mapController})
      : assert(mapController != null) {
    // init state
    _markersState = MarkersState(mapController: mapController, notify: notify);
    _linesState = LinesState(notify: notify);
    _polygonsState = PolygonsState(notify: notify);
    _mapState = LiveMapState(
        mapController: mapController,
        notify: notify,
        markersState: _markersState);
    mapController.onReady.then((_) {
      // fire the map is ready callback
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.complete();
      }
    });
  }

  /// The Flutter Map [MapController]
  final MapController mapController;

  /// The Flutter Map [MapOptions]
  MapOptions mapOptions;

  LiveMapState _mapState;
  MarkersState _markersState;
  LinesState _linesState;
  PolygonsState _polygonsState;

  final Completer<Null> _readyCompleter = Completer<Null>();
  final _subject = PublishSubject<StatefulMapControllerStateChange>();

  /// On ready callback: this is fired when the contoller is ready
  Future<Null> get onReady => _readyCompleter.future;

  /// A stream with changes occuring on the map
  Observable<StatefulMapControllerStateChange> get changeFeed =>
      _subject.distinct();

  /// The map zoom value
  double get zoom => mapController.zoom;

  /// The map center value
  LatLng get center => mapController.center;

  /// The markers present on the map
  List<Marker> get markers => _markersState.markers;

  /// The markers present on the map and their names
  Map<String, Marker> get namedMarkers => _markersState.namedMarkers;

  /// The lines present on the map
  List<Polyline> get lines => _linesState.lines;

  /// The polygons present on the map
  List<Polygon> get polygons => _polygonsState.polygons;

  /// Zoom in one level
  Future<void> zoomIn() => _mapState.zoomIn();

  /// Zoom out one level
  Future<void> zoomOut() => _mapState.zoomOut();

  /// Zoom to level
  Future<void> zoomTo(double value) => _mapState.zoomTo(value);

  /// Center the map on a [LatLng]
  Future<void> centerOnPoint(LatLng point) => _mapState.centerOnPoint(point);

  /// The callback used to handle gestures and keep the state in sync
  void onPositionChanged(MapPosition pos, bool gesture) =>
      _mapState.onPositionChanged(pos, gesture);

  /// Add a marker on the map
  Future<void> addMarker({@required Marker marker, @required String name}) =>
      _markersState.addMarker(marker: marker, name: name);

  /// Remove a marker from the map
  Future<void> removeMarker({@required String name}) =>
      _markersState.removeMarker(name: name);

  /// Add multiple markers to the map
  Future<void> addMarkers({@required Map<String, Marker> markers}) =>
      _markersState.addMarkers(markers: markers);

  /// Remove multiple makers from the map
  Future<void> removeMarkers({@required List<String> names}) =>
      _markersState.removeMarkers(names: names);

  /// Add a line on the map
  Future<void> addLine(
          {@required String name,
          @required List<LatLng> points,
          double width = 1.0,
          Color color = Colors.green,
          bool isDotted = false}) =>
      _linesState.addLine(
          name: name,
          points: points,
          color: color,
          width: width,
          isDotted: isDotted);

  /// Add a polygon on the map
  Future<void> addPolygon(
          {@required String name,
          @required List<LatLng> points,
          Color color = const Color(0xFF00FF00),
          double borderWidth = 0.0,
          Color borderColor = const Color(0xFFFFFF00)}) =>
      _polygonsState.addPolygon(
          name: name,
          points: points,
          color: color,
          borderWidth: borderWidth,
          borderColor: borderColor);

  /// Notify to the changefeed
  void notify(String name, dynamic value, Function from) {
    StatefulMapControllerStateChange change =
        StatefulMapControllerStateChange(name: name, value: value, from: from);
    //if (change.name != "updateMarkers") print("STATE MUTATION: $change");
    _subject.add(change);
  }
}
