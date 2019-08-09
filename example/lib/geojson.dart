import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';

class _GeoJsonPageState extends State<GeoJsonPage> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  void loadData() async {
    // data is from http://geojson.xyz/
    print("Loading geojson data");
    final data = await rootBundle.loadString('assets/airports.geojson');
    unawaited(statefulMapController.fromGeoJson(data,
        markerIcon: Icon(Icons.local_airport), verbose: true));
  }

  @override
  void initState() {
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => loadData());
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
          center: LatLng(0.0, 0.0),
          zoom: 1.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: statefulMapController.markers,
          ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class GeoJsonPage extends StatefulWidget {
  @override
  _GeoJsonPageState createState() => _GeoJsonPageState();
}
