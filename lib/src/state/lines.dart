import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

/// State of the lines on the map
class LinesState {
  /// Default contructor
  LinesState({@required this.notify}) : assert(notify != null);

  /// The notify function
  final Function notify;

  final Map<String, Polyline> _namedLines = {};

  /// The lines present on the map
  List<Polyline> get lines => _namedLines.values.toList();

  /// Add a line on the map
  Future<void> addLine(
      {@required String name,
      @required List<LatLng> points,
      double width = 1.0,
      Color color = Colors.green,
      bool isDotted = false}) async {
    //print("ADD LINE $name of ${points.length} points");
    _namedLines[name] = Polyline(
        points: points, strokeWidth: width, color: color, isDotted: isDotted);
    notify("updateLines", _namedLines[name], addLine);
  }
}
