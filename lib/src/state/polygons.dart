import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_controller_plus/src/controller.dart';
import 'package:map_controller_plus/src/models.dart';

/// State of the polygons on the map
class PolygonsState {
  /// Default contructor
  PolygonsState({required this.notify});

  /// The notify function
  final FeedNotifyFunction notify;

  final _namedPolygons = <String, Polygon>{};

  /// The named polygons on the map
  Map<String, Polygon> get namedPolygons => _namedPolygons;

  /// The lines present on the map
  List<Polygon> get polygons => _namedPolygons.values.toList();

  /// Add a polygon on the map
  void addPolygon({
    required String name,
    required List<LatLng> points,
    required Color color,
    required double borderWidth,
    required Color borderColor,
  }) {
    _namedPolygons[name] = Polygon(
      points: points,
      color: color,
      borderStrokeWidth: borderWidth,
      borderColor: borderColor,
    );
    notify(
      "updatePolygons",
      _namedPolygons[name],
      addPolygon,
      MapControllerChangeType.polygons,
    );
  }

  /// Remove a polygon from the map
  void removePolygon(String name) {
    if (_namedPolygons.containsKey(name)) {
      _namedPolygons.remove(name);
      notify(
        "updatePolygons",
        name,
        removePolygon,
        MapControllerChangeType.polygons,
      );
    }
  }

  /// Remove multiple polygons from the map
  void removePolygons(List<String> names) {
    _namedPolygons.removeWhere((key, value) => names.contains(key));
    notify(
      "updatePolygons",
      names,
      removePolygons,
      MapControllerChangeType.polygons,
    );
  }

  /// Export all polygons to a [GeoJsonFeature] with geometry
  /// type [GeoJsonMultiPolygon]
  GeoJsonFeature<GeoJsonMultiPolygon>? toGeoJsonFeatures() {
    if (namedPolygons.isEmpty) return null;

    final multiPolygon = GeoJsonMultiPolygon(name: "map_polygons");
    for (final entry in namedPolygons.entries) {
      final mapPolygon = entry.value;
      final polygon = GeoJsonPolygon()..name = entry.key;
      final geoSerie = GeoSerie(name: entry.key, type: GeoSerieType.polygon);

      for (final point in mapPolygon.points) {
        geoSerie.geoPoints.add(
          GeoPoint(latitude: point.latitude, longitude: point.longitude),
        );
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
