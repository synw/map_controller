import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

/// State of the polygons on the map
class PolygonsState {
  /// Default contructor
  PolygonsState({@required this.notify}) : assert(notify != null);

  /// The notify function
  final Function notify;

  final Map<String, Polygon> _namedPolygons = {};

  /// The lines present on the map
  List<Polygon> get polygons => _namedPolygons.values.toList();

  /// Add a polygon on the map
  Future<void> addPolygon(
      {@required String name,
      @required List<LatLng> points,
      Color color,
      double borderWidth,
      Color borderColor}) async {
    _namedPolygons[name] = Polygon(
        points: points,
        color: color,
        borderStrokeWidth: borderWidth,
        borderColor: borderColor);
    notify("updatePolygons", _namedPolygons[name], addPolygon);
  }
}
