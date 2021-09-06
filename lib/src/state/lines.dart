import 'package:flutter_map/flutter_map.dart';

import '../models.dart';

/// State of the lines on the map
class LinesState {
  /// Default contructor
  LinesState({required this.notify});

  /// The notify function
  final Function notify;

  final Map<String, Polyline> _namedLines = {};

  /// The named lines on the map
  Map<String, Polyline> get namedLines => _namedLines;

  /// The lines present on the map
  List<Polyline> get lines => _namedLines.values.toList();

  /// Add a line on the map
  Future<void> addLine({required String name, required Polyline line}) async {
    _namedLines[name] = line;
    notify("updateLines", _namedLines[name], addLine,
        MapControllerChangeType.lines);
  }

  /// Remove a line from the map
  Future<void> removeLine(String name) async {
    if (_namedLines.containsKey(name)) {
      _namedLines.remove(name);
      notify("updateLines", name, removeLine, MapControllerChangeType.lines);
    }
  }
}
