import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

typedef StatefulMarkerBuidler = Widget Function(
    BuildContext, Map<String, dynamic>);

class StatefulMarker {
  StatefulMarker({
    required this.point,
    required this.state,
    required this.builder,
    this.width = 30.0,
    this.height = 30.0,
    this.anchorAlign = AnchorAlign.center,
  });

  final LatLng point;
  final double width;
  final double height;
  final AnchorAlign anchorAlign;
  final Map<String, dynamic> state;
  StatefulMarkerBuidler builder;

  Marker get marker => _build();

  void mutate(String name, dynamic value) => state[name] = value;

  Marker _build() {
    return Marker(
        anchorPos: AnchorPos.align(anchorAlign),
        point: point,
        width: width,
        height: height,
        builder: (BuildContext c) => builder(c, state));
  }
}

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
  StatefulMapControllerStateChange({
    required this.type,
    required this.name,
    required this.value,
    this.from,
  });

  /// Name of the change
  final String name;

  /// Value of the change
  final dynamic value;

  /// Where the change comes from
  final Function? from;

  /// The change type
  final MapControllerChangeType type;

  /// String representation
  @override
  String toString() {
    return "$name $value from $from";
  }
}
