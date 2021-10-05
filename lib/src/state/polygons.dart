import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import '../models.dart';

/// State of the polygons on the map
class PolygonsState {
  /// Default contructor
  PolygonsState({required this.notify}) : assert(notify != null);

  /// The notify function
  final Function notify;

  final Map<String, Polygon> _namedPolygons = {};

  /// The named polygons on the map
  Map<String, Polygon> get namedPolygons => _namedPolygons;

  /// The lines present on the map
  List<Polygon> get polygons => _namedPolygons.values.toList();

  /// Add a polygon on the map
  Future<void> addPolygon(
      {required String name,
      required List<LatLng> points,
      required Color color,
      required double borderWidth,
      required Color borderColor}) async {
    _namedPolygons[name] = Polygon(
        points: points,
        color: color,
        borderStrokeWidth: borderWidth,
        borderColor: borderColor);
    notify("updatePolygons", _namedPolygons[name], addPolygon,
        MapControllerChangeType.polygons);
  }

  /// Remove a polygon from the map
  Future<void> removePolygon(String name) async {
    if (_namedPolygons.containsKey(name)) {
      _namedPolygons.remove(name);
      notify("updatePolygons", name, removePolygon,
          MapControllerChangeType.polygons);
    }
  }

  /// Export all polygons to a [GeoJsonFeature] with geometry
  /// type [GeoJsonMultiPolygon]
  GeoJsonFeature<GeoJsonMultiPolygon>? toGeoJsonFeatures() {
    if (namedPolygons.isEmpty) {
      return null;
    }
    final multiPolygon = GeoJsonMultiPolygon(name: "map_polygons");
    for (final k in namedPolygons.keys) {
      final mapPolygon = namedPolygons[k]!;
      final polygon = GeoJsonPolygon()..name = k;
      final geoSerie = GeoSerie(name: polygon.name!, type: GeoSerieType.polygon);
      for (final point in mapPolygon.points) {
        geoSerie.geoPoints.add(
            GeoPoint(latitude: point.latitude, longitude: point.longitude));
      }
      polygon.geoSeries = [geoSerie];
      multiPolygon.polygons.add(polygon);
    }
    final feature = GeoJsonFeature<GeoJsonMultiPolygon>()
      ..type = GeoJsonFeatureType.multipolygon
      ..geometry = multiPolygon
      ..properties = <String, dynamic>{"name": "map_polygons"};
    return feature;
  }
}
