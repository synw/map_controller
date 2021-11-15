import 'package:flutter_map/flutter_map.dart';

import '../controller.dart';
import '../models.dart';

class StatefulMarkersState {
  /// Provide a [MapController]
  StatefulMarkersState({required this.mapController, required this.notify});

  /// The Flutter Map controller
  final MapController mapController;

  /// The notification function
  final FeedNotifyFunction notify;

  final _statefulMarkers = <String, StatefulMarker>{};
  final _namedMarkers = <String?, Marker>{};

  List<Marker> get markers => _namedMarkers.values.toList();
  Map<String, StatefulMarker> get statefulMarkers => _statefulMarkers;

  void addStatefulMarker(String name, StatefulMarker statefulMarker) {
    _statefulMarkers[name] = statefulMarker;
    _namedMarkers[name] = statefulMarker.marker;
    notify(
      "updateMarkers",
      statefulMarker,
      addStatefulMarker,
      MapControllerChangeType.markers,
    );
  }

  void addStatefulMarkers(Map<String, StatefulMarker> statefulMarkers) {
    for (final entry in statefulMarkers.entries) {
      _statefulMarkers[entry.key] = entry.value;
      _namedMarkers[entry.key] = entry.value.marker;
    }
    notify(
      "updateMarkers",
      statefulMarkers,
      addStatefulMarkers,
      MapControllerChangeType.markers,
    );
  }

  void mutate(String name, String property, dynamic value) {
    _statefulMarkers[name]!.mutate(property, value);
    addStatefulMarker(name, _statefulMarkers[name]!);
  }
}
