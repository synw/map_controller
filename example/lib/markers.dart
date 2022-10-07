import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_controller_plus/map_controller_plus.dart';

class Place {
  Place(this.name, this.point);

  final String name;
  final LatLng point;
}

class _MarkersPageState extends State<MarkersPage> {
  final mapController = MapController();
  late final statefulMapController =
      StatefulMapController(mapController: mapController);
  late final StreamSubscription<StatefulMapControllerStateChange> sub;

  final List<Place> places = [
    Place("Notre-Dame", LatLng(48.853831, 2.348722)),
    Place("Montmartre", LatLng(48.886463, 2.341169)),
    Place("Champs-Elysées", LatLng(48.873932, 2.294821)),
    Place("Chinatown", LatLng(48.827393, 2.361897)),
    Place("Tour Eiffel", LatLng(48.85801, 2.294713))
  ];

  final _markersOnMap = <Place>[];

  void addMarker(BuildContext context) {
    for (final place in places) {
      if (!_markersOnMap.contains(place)) {
        debugPrint("Adding marker ${place.name}");
        statefulMapController.addMarker(
            name: place.name,
            marker: Marker(
                point: place.point,
                builder: (BuildContext context) {
                  return const Icon(Icons.location_on);
                }));
        _markersOnMap.add(place);
        return;
      }
    }
  }

  @override
  void initState() {
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(48.853831, 2.348722),
            zoom: 11.0,
          ),
          children: [
            statefulMapController.tileLayer!,
            MarkerLayer(
              markers: statefulMapController.markers,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addMarker(context),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    sub.cancel();
    super.dispose();
  }
}

class MarkersPage extends StatefulWidget {
  const MarkersPage({Key? key}) : super(key: key);

  @override
  _MarkersPageState createState() => _MarkersPageState();
}
