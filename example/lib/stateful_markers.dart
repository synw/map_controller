import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_controller/map_controller.dart';

class Place {
  Place(this.name, this.point);

  final String name;
  final LatLng point;
}

class _StatefulMarkersPageState extends State<StatefulMarkersPage> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  final List<Place> places = [
    Place("Notre-Dame", LatLng(48.853831, 2.348722)),
    Place("Montmartre", LatLng(48.886463, 2.341169)),
    Place("Champs-Elysées", LatLng(48.873932, 2.294821)),
    Place("Chinatown", LatLng(48.827393, 2.361897)),
    Place("Tour Eiffel", LatLng(48.85801, 2.294713))
  ];

  final _markersOnMap = <Place>[];
  bool ready = false;

  void addMarker(BuildContext context) {
    for (final place in places) {
      if (!_markersOnMap.contains(place)) {
        print("Adding marker ${place.name}");
        statefulMapController.addStatefulMarker(
            name: place.name,
            statefulMarker: StatefulMarker(
                //anchorAlign: AnchorAlign.bottom,
                height: 80.0,
                width: 150.0,
                state: <String, dynamic>{"showText": false},
                point: place.point,
                builder: (BuildContext context, Map<String, dynamic> state) {
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
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => setState(() => ready = true));
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
          layers: [
            statefulMapController.tileLayer,
            MarkerLayerOptions(
              markers: statefulMapController.markers,
            ),
          ],
        ),
      ),
      floatingActionButton: ready
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => addMarker(context),
            )
          : const Text(""),
    );
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class StatefulMarkersPage extends StatefulWidget {
  @override
  _StatefulMarkersPageState createState() => _StatefulMarkersPageState();
}
