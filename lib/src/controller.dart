import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/src/exceptions.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

import '../map_controller.dart';
import 'models.dart';
import 'state/lines.dart';
import 'state/map.dart';
import 'state/markers.dart';
import 'state/polygons.dart';
import 'state/stateful_markers.dart';
import 'state/tile_layer.dart';
import 'types.dart';

/// The map controller
class StatefulMapController {
  /// Provide a Flutter map [MapController]
  StatefulMapController(
      {@required this.mapController,
      this.tileLayerType = TileLayerType.normal,
      this.customTileLayer,
      this.verbose = false})
      : assert(mapController != null) {
    // init state
    _markersState = MarkersState(mapController: mapController, notify: notify);
    _linesState = LinesState(notify: notify);
    _polygonsState = PolygonsState(notify: notify);
    _mapState = MapState(mapController: mapController, notify: notify);
    _statefulMarkersState =
        StatefulMarkersState(mapController: mapController, notify: notify);
    if (customTileLayer != null) {
      tileLayerType = TileLayerType.custom;
    }
    _tileLayerState = TileLayerState(
        type: tileLayerType, customTileLayer: customTileLayer, notify: notify);
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

  /// The initial tile layer
  TileLayerType tileLayerType;

  /// A custom tile layer options
  TileLayerOptions customTileLayer;

  /// Verbosity level
  final bool verbose;

  MapState _mapState;
  MarkersState _markersState;
  LinesState _linesState;
  PolygonsState _polygonsState;
  TileLayerState _tileLayerState;
  StatefulMarkersState _statefulMarkersState;

  final Completer<void> _readyCompleter = Completer<void>();
  final _subject = PublishSubject<StatefulMapControllerStateChange>();

  /// On ready callback: this is fired when the contoller is ready
  Future<void> get onReady => _readyCompleter.future;

  /// A stream with changes occuring on the map
  Stream<StatefulMapControllerStateChange> get changeFeed =>
      _subject.distinct();

  /// The map zoom value
  double get zoom => mapController.zoom;

  /// Rotate the map
  set rotate(double degree) => mapController.rotate(degree);

  /// The map center value
  LatLng get center => mapController.center;

  /// The stateful markers present on the map
  Map<String, StatefulMarker> get statefulMarkers =>
      _statefulMarkersState.statefulMarkers;

  void addStatefulMarker({String name, StatefulMarker statefulMarker}) =>
      _statefulMarkersState.addStatefulMarker(name, statefulMarker);

  void addStatefulMarkers(Map<String, StatefulMarker> statefulMarkers) =>
      _statefulMarkersState.addStatefulMarkers(statefulMarkers);

  void mutateMarker({String name, String property, dynamic value}) =>
      _statefulMarkersState.mutate(name, property, value);

  /// The markers present on the map
  List<Marker> get markers =>
      _markersState.markers..addAll(_statefulMarkersState.markers);

  /// Return a [Marker] corresponding to [name] from the
  /// [StatefulMarkersState].
  Marker getMarker(String name) {
    final marker = _statefulMarkersState.statefulMarkers[name];
    return marker?.marker;
  }

  /// Return all [Marker] corresponding with [names].
  /// If one of the name doesn't correspond to any marker it is not added
  /// to the returned [List<Marker>].
  /// If no markers were found return an empty [List<Marker>].
  List<Marker> getMarkers(List<String> names) {
    final markers = <Marker>[];
    names.forEach((name) {
      final marker = getMarker(name);
      if (marker != null) markers.add(marker);
    });
    return markers;
  }

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

  /// The current map tile layer
  TileLayerOptions get tileLayer => _tileLayerState.tileLayer;

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

  /// Fit bounds for all markers on map
  Future<void> fitMarkers() async => _markersState.fitAll();

  /// Fit bounds for one marker on map
  Future<void> fitMarker(String name) async => _markersState.fitOne(name);

  /// Fit bounds and zoom the map to center on a line
  Future<void> fitLine(String name) async {
    final line = _linesState.namedLines[name];
    final bounds = LatLngBounds();
    line.points.forEach(bounds.extend);
    mapController.fitBounds(bounds);
  }

  /// Add a line on the map
  Future<void> addLine(
      {@required String name,
      @required List<LatLng> points,
      double width = 3.0,
      Color color = Colors.green,
      bool isDotted = false}) async {
    await _linesState.addLine(
        name: name,
        points: points,
        color: color,
        width: width,
        isDotted: isDotted);
  }

  /// Add a line on the map
  Future<void> addLineFromGeoPoints(
      {@required String name,
      @required List<GeoPoint> geoPoints,
      double width = 3.0,
      Color color = Colors.green,
      bool isDotted = false}) async {
    final points =
        GeoSerie(type: GeoSerieType.line, name: "serie", geoPoints: geoPoints)
            .toLatLng();
    await _linesState.addLine(
        name: name,
        points: points,
        color: color,
        width: width,
        isDotted: isDotted);
  }

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

  /// Switch to a tile layer
  void switchTileLayer(TileLayerType layer) =>
      _tileLayerState.switchTileLayer(layer);

  /// Display some geojson data on the map
  Future<void> fromGeoJson(String data,
      {bool verbose = false,
      Icon markerIcon = const Icon(Icons.location_on),
      bool noIsolate = false}) async {
    print("From geojson $data");

    final geojson = GeoJson();
    // ignore: strict_raw_type
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
          break;
        case GeoJsonFeatureType.geometryCollection:
          // TODO : implement
          throw const NotImplementedException(
              "GeoJsonFeatureType.geometryCollection Not implemented");
      }
    });
    if (noIsolate) {
      await geojson.parseInMainThread(data);
    } else {
      await geojson.parse(data);
    }
  }

  /// Export all the map assets to a [GeoJsonFeatureCollection]
  GeoJsonFeatureCollection toGeoJsonFeatures() {
    final featureCollection = GeoJsonFeatureCollection()
      // ignore: strict_raw_type
      ..collection = <GeoJsonFeature>[];
    final markersFeature = _markersState.toGeoJsonFeatures();
    final linesFeature = _linesState.toGeoJsonFeatures();
    final polygonsFeature = _polygonsState.toGeoJsonFeatures();
    if (markersFeature != null) {
      featureCollection.collection.add(markersFeature);
    }
    if (linesFeature != null) {
      featureCollection.collection.add(linesFeature);
    }
    if (polygonsFeature != null) {
      featureCollection.collection.add(polygonsFeature);
    }
    return featureCollection;
  }

  /// Convert the map assets to a geojson string
  String toGeoJson() => toGeoJsonFeatures().serialize();

  /// Notify to the changefeed
  void notify(
      String name, dynamic value, Function from, MapControllerChangeType type) {
    final change = StatefulMapControllerStateChange(
        name: name, value: value, from: from, type: type);
    if (verbose) {
      print("Map state change: $change");
    }
    _subject.add(change);
  }
}
