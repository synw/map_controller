# Map Controller Plus

[![Pub Version](https://img.shields.io/pub/v/map_controller_plus)](https://pub.dev/packages/map_controller_plus)

Stateful map controller for Flutter Map. Manage markers, lines and polygons.

**This is a fork from [synw's map_controller package](https://pub.dev/packages/map_controller) made because the project has been abandoned. This new and improved version supports the latest version of the [flutter_map](https://pub.dev/packages/flutter_map) package. If you need a feature or a fix you can [open an issue on the forked repository](https://github.com/TesteurManiak/map_controller/issues).**

## Usage

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_controller_plus/map_controller_plus.dart';

class MapPage extends StatefulWidget {
   @override
   State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
   late final MapController mapController;
   late final StatefulMapController statefulMapController;
   late final StreamSubscription<StatefulMapControllerStateChange> sub;
   
   @override
   void initState() {
      super.initState();

      // intialize the controllers
      mapController = MapController();
      statefulMapController = StatefulMapController(mapController: mapController);

      /// [Important] listen to the changefeed to rebuild the map on changes:
      /// this will rebuild the map when for example addMarker or any method 
      /// that mutates the map assets is called
      sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
   }

   @override
   void dispose() {
      sub.cancel();
      mapController.dispose();
      super.dispose();
   }
   
   @override
   Widget build(BuildContext context) {
      return Scaffold(
         body: SafeArea(
            child: Stack(children: <Widget>[
               FlutterMap(
                  mapController: mapController,
                  options: MapOptions(center: LatLng(48.853831, 2.348722), zoom: 11.0),
                  children: [
                     MarkerLayer(markers: statefulMapController.markers),
                     PolylineLayer(polylines: statefulMapController.lines),
                     PolygonLayer(polygons: statefulMapController.polygons),
                  ],
               ),
            // ...
         ])),
      );
   }
}
```

## Api

Api for the [StatefulMapController](https://pub.dev/documentation/map_controller/latest/map_controller/StatefulMapController-class.html) class

### Map controls

#### Zoom

* `zoom`: get the current zoom value
* `zoomIn()`: increase the zoom level by 1
* `zoomOut()`: decrease the zoom level by 1
* `zoomTo()`: zoom to the provided value

#### Center

* `center`: get the current center `LatLng` value
* `centerOnPoint()`: center on the `LatLng` value

### Map assets

#### Markers

* `addMarker()`: add a named marker on the map
* `addMarkers()`: add several named markers on the map
* `removeMarker()`: remove a named marker from the map
* `removeMarkers()`: remove several named markers from the map
* `markers`: get the markers that are on the map
* `namedMarkers`: get the markers with their names that are on the map
* `getMarker()`: return the marker with the corresponding name
* `getMarkers()`: return the markers with the corresponding names

#### Stateful markers

*New in 0.7*: the stateful makers hold their own state and can be mutated 

```dart
statefulMapController.addStatefulMarker(
   name: "some marker",
   statefulMarker: StatefulMarker(
      height: 80.0,
      width: 120.0,
      state: <String, dynamic>{"showText": false},
      point: LatLng(48.853831, 2.348722),
      builder: (BuildContext context, Map<String, dynamic> state) {
         Widget w;
         final markerIcon = IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => statefulMapController.mutateMarker(
               name: "some marker",
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
      })
);
```

#### Lines

* `addLine()`: add a line on the map
* `lines`: get the lines that are on the map

#### Polygons

* `addPolygon`: add a polygon on the map
* `polygons`: get the polygons that are on the map

### Changefeed

A changefeed is available: it's a stream with all state changes from the map controller. Use it to update the map when a change occurs:

```dart
statefulMapController.changeFeed.listen((change) => setState(() {}));
```

### Geojson data

The map controller can draw on the map from geojson data:

```dart
void loadData() async {
  print("Loading geojson data");
  final data = await rootBundle.loadString('assets/airports.geojson');
  await statefulMapController.fromGeoJson(data,
    markerIcon: Icon(Icons.local_airport), verbose: true);
}

@override
void initState() {
  super.initState();
  mapController = MapController();
  statefulMapController = StatefulMapController(mapController: mapController);
  loadData();
  sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
}
```

### Tile layer management

Some predefined tile layers are available.

```dart
FlutterMap(
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
      MarkerLayer(markers: statefulMapController.markers),
      
      // ...
   ],
)
```