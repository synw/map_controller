import 'package:flutter_map/flutter_map.dart';

import '../controller.dart';
import '../models.dart';

/// State of the lines on the map
class LinesState {
  /// Default contructor
  LinesState({required this.notify});

  /// The notify function
  final FeedNotifyFunction notify;

  final Map<String, Polyline> _namedLines = {};

  /// The named lines on the map
  Map<String, Polyline> get namedLines => _namedLines;

  /// The lines present on the map
  List<Polyline> get lines => _namedLines.values.toList();

  /// Add a line on the map
  void addLine({required String name, required Polyline line}) {
    _namedLines[name] = line;
    notify("updateLines", _namedLines[name], addLine,
        MapControllerChangeType.lines);
  }

  /// Remove a line from the map
  void removeLine(String name) {
    if (_namedLines.containsKey(name)) {
      _namedLines.remove(name);
      notify("updateLines", name, removeLine, MapControllerChangeType.lines);
    }
  }

  /// Remove multiple lines from the map
  void removeLines(List<String> names) async {
    for (String name in names) {
      removeLine(name);
    }
  }
}
