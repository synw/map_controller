import 'package:flutter/foundation.dart';

/// The type of the controller change
enum MapControllerChangeType {
  /// Update center
  center,

  /// Update zoom
  zoom,

  /// Update markers
  markers,

  /// Update lines
  lines,

  /// Update polygons
  polygons,

  /// Update position stream state
  positionStream,

  /// Change the tile layer
  tileLayer
}

/// Desctiption of a state change
class StatefulMapControllerStateChange {
  /// Name and value of the change
  StatefulMapControllerStateChange(
      {@required this.type,
      @required this.name,
      @required this.value,
      this.from})
      : assert(name != null),
        assert(type != null);

  /// Name of the change
  final String name;

  /// Value of the change
  final dynamic value;

  /// Where the change comes from
  final Function from;

  /// The change type
  final MapControllerChangeType type;

  /// String representation
  @override
  String toString() {
    return "${this.name} ${this.value} from ${this.from}";
  }
}
