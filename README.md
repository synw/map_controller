# Map Controller Plus

Stateful map controller for Flutter Map. Manage markers, lines and polygons.

**This is a fork from [synw's map_controller package](https://pub.dev/packages/map_controller) made because the project has been abandoned. This new and improved version supports the latest version of the [flutter_map](https://pub.dev/packages/flutter_map) package. If you need a feature or a fix you can [open an issue on the forked repository](https://github.com/TesteurManiak/map_controller/issues).**

## Usage

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';

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

      // wait for the controller to be ready before using it
      statefulMapController.onReady.then((_) => print("The map controller is ready")));

      /// [Important] listen to the changefeed to rebuild the map on changes:
      /// this will rebuild the map when for example addMarker or any method 
      /// that mutates the map assets is called
      sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
   }
   
   @override
   Widget build(BuildContext context) {
      return Scaffold(
         body: SafeArea(
            child: Stack(children: <Widget>[
               FlutterMap(
                  mapController: mapController,
                  options: MapOptions(center: LatLng(48.853831, 2.348722), zoom: 11.0),
                  layers: [
                     MarkerLayerOptions(markers: statefulMapController.markers),
                     PolylineLayerOptions(polylines: statefulMapController.lines),
                     PolygonLayerOptions(polygons: statefulMapController.polygons),
                  ],
               ),
            // ...
         ])),
      );
   }
   
   @override
   void dispose() {
      sub.cancel();
      super.dispose();
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

### On ready callback

Execute some code right after the map is ready:

```dart
@override
void initState() {
   super.initState();
   statefulMapController.onReady.then((_) {
      setState((_) =>_ready = true);
   });
}
```

### Changefeed

A changefeed is available: it's a stream with all state changes from the map controller. Use it to update the map when a change occurs:

```dart
statefulMapController.onReady.then((_) {
   statefulMapController.changeFeed.listen((change) => setState(() {}));
});
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
  mapController = MapController();
  statefulMapController = StatefulMapController(mapController: mapController);
  statefulMapController.onReady.then((_) => loadData());
  sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
  super.initState();
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
   layers: [
      // Use the map controller's tile layer
      statefulMapController.tileLayer,
      MarkerLayerOptions(markers: statefulMapController.markers),
      
      // ...
   ],
)
```

To switch tile layers at runtime use:

```dart
statefulMapController.switchTileLayer(TileLayerType.monochrome);
```

Available layers:

```dart
TileLayerType.normal
TileLayerType.topography
TileLayerType.monochrome
TileLayerType.hike
```

A tile layers bar is available:

```dart
Stack(
   children: <Widget>[
      FlutterMap(
         mapController: mapController,
         options: MapOptions(
            center: LatLng(48.853831, 2.348722),
            zoom: 11.0,
         ),
         layers: [
            statefulMapController.tileLayer,
            MarkerLayerOptions(markers: statefulMapController.markers),
         ],
      ),
      Positioned(
         top: 15.0,
         right: 15.0,
         child: TileLayersBar(controller: statefulMapController),
      ),
   ],
);
```
