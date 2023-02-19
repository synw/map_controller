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

class _StatefulMarkersPageState extends State<StatefulMarkersPage> {
  final mapController = MapController();

  late final statefulMapController = StatefulMapController(
    mapController: mapController,
  );
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
        statefulMapController.addStatefulMarker(
            name: place.name,
            statefulMarker: StatefulMarker(
                //anchorAlign: AnchorAlign.bottom,
                height: 80.0,
                width: 150.0,
                state: <String, dynamic>{"showText": false},
                point: place.point,
                builder: (context, state) {
                  Widget w;
                  final markerIcon = IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () => statefulMapController.mutateMarker(
                          name: place.name,
                          property: "showText",
                          value: !(state["showText"] as bool)));
                  if (state["showText"] == true) {
                    w = Column(children: <Widget>[
                      markerIcon,
                      Container(
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(place.name, textScaleFactor: 1.3))),
                    ]);
                  } else {
                    w = markerIcon;
                  }
                  return w;
                }));
        _markersOnMap.add(place);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
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
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            ),
            MarkerLayer(
                markers: statefulMapController
                    .getMarkers(['Notre-Dame', 'Montmartre'])),
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
    sub.cancel();
    super.dispose();
  }
}

class StatefulMarkersPage extends StatefulWidget {
  const StatefulMarkersPage({Key? key}) : super(key: key);

  @override
  _StatefulMarkersPageState createState() => _StatefulMarkersPageState();
}
