import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:geojson/geojson.dart';
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
    _mapState = MapState(
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

  MapState _mapState;
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

  /// The named lines present on the map
  Map<String, Polyline> get namedLines => _linesState.namedLines;

  /// The polygons present on the map
  List<Polygon> get polygons => _polygonsState.polygons;

  /// The named polygons present on the map
  Map<String, Polygon> get namedPolygons => _polygonsState.namedPolygons;

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
          double width = 3.0,
          Color color = Colors.green,
          bool isDotted = false}) =>
      _linesState.addLine(
          name: name,
          points: points,
          color: color,
          width: width,
          isDotted: isDotted);

  /// Remove a line from the map
  Future<void> removeLine(String name) => _linesState.removeLine(name);

  /// Remove a polygon from the map
  Future<void> removePolygon(String name) => _polygonsState.removePolygon(name);

  /// Add a polygon on the map
  Future<void> addPolygon(
          {@required String name,
          @required List<LatLng> points,
          Color color = Colors.lightBlue,
          double borderWidth = 0.0,
          Color borderColor = const Color(0xFFFFFF00)}) =>
      _polygonsState.addPolygon(
          name: name,
          points: points,
          color: color,
          borderWidth: borderWidth,
          borderColor: borderColor);

  /// Display some geojson data on the map
  Future<void> fromGeoJson(String data,
      {bool verbose = false,
      Icon markerIcon = const Icon(Icons.location_on)}) async {
    final geojson = GeoJson();
    geojson.processedFeatures.listen((GeoJsonFeature feature) {
      switch (feature.type) {
        case GeoJsonFeatureType.point:
          final point = feature.geometry as GeoJsonPoint;
          unawaited(addMarker(
            name: point.name,
            marker: Marker(
                point:
                    LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
                builder: (BuildContext context) => markerIcon),
          ));
          break;
        case GeoJsonFeatureType.multipoint:
          final mp = feature.geometry as GeoJsonMultiPoint;
          for (final geoPoint in mp.geoSerie.geoPoints) {
            unawaited(addMarker(
              name: geoPoint.name,
              marker: Marker(
                  point: LatLng(geoPoint.latitude, geoPoint.longitude),
                  builder: (BuildContext context) => markerIcon),
            ));
          }
          break;
        case GeoJsonFeatureType.line:
          final line = feature.geometry as GeoJsonLine;
          unawaited(addLine(name: line.name, points: line.geoSerie.toLatLng()));
          break;
        case GeoJsonFeatureType.multiline:
          final ml = feature.geometry as GeoJsonMultiLine;
          for (final line in ml.lines) {
            unawaited(
                addLine(name: line.name, points: line.geoSerie.toLatLng()));
          }
          break;
        case GeoJsonFeatureType.polygon:
          final poly = feature.geometry as GeoJsonPolygon;
          for (final geoSerie in poly.geoSeries) {
            unawaited(
                addPolygon(name: geoSerie.name, points: geoSerie.toLatLng()));
          }
          break;
        case GeoJsonFeatureType.multipolygon:
          final mp = feature.geometry as GeoJsonMultiPolygon;
          for (final poly in mp.polygons) {
            for (final geoSerie in poly.geoSeries) {
              unawaited(
                  addPolygon(name: geoSerie.name, points: geoSerie.toLatLng()));
            }
          }
      }
    });
    unawaited(geojson.parse(data));
  }

  /// Notify to the changefeed
  void notify(
      String name, dynamic value, Function from, MapControllerChangeType type) {
    StatefulMapControllerStateChange change = StatefulMapControllerStateChange(
        name: name, value: value, from: from, type: type);
    //print("STATE MUTATION: $change");
    _subject.add(change);
  }
}
