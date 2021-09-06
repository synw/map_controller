import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models.dart';

/// State of the polygons on the map
class PolygonsState {
  /// Default contructor
  PolygonsState({required this.notify});

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
}
