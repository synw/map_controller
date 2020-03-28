# Map controller

[![pub package](https://img.shields.io/pub/v/map_controller.svg)](https://pub.dartlang.org/packages/map_controller)

Stateful map controller for Flutter Map. Manage markers, lines and polygons.

[View the web demo](https://synw.github.io/map_controller)

## Usage

   ```dart
   import 'dart:async';
   import 'package:flutter/material.dart';
   import 'package:flutter_map/flutter_map.dart';
   import 'package:latlong/latlong.dart';
   import 'package:map_controller/map_controller.dart';

   class _MapPageState extends State<MapPage> {
     MapController mapController;
     StatefulMapController statefulMapController;
     StreamSubscription<StatefulMapControllerStateChange> sub;
   
     @override
     void initState() {
       // intialize the controllers
       mapController = MapController();
       statefulMapController = StatefulMapController(mapController: mapController);

       // wait for the controller to be ready before using it
       statefulMapController.onReady.then((_) => print("The map controller is ready")));

       /// [Important] listen to the changefeed to rebuild the map on changes:
       /// this will rebuild the map when for example addMarker or any method 
       /// that mutates the map assets is called
       sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
       super.initState();
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
               PolygonLayerOptions(polygons: statefulMapController.polygons)
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
   
   class MapPage extends StatefulWidget {
     @override
     _MapPageState createState() => _MapPageState();
   }
   ```

## Api

Api for the [StatefulMapController](https://pub.dev/documentation/map_controller/latest/map_controller/StatefulMapController-class.html) class

### Map controls

#### Zoom

**`zoom`**: get the current zoom value

**`zoomIn()`**: increase the zoom level by 1

**`zoomOut()`**: decrease the zoom level by 1

**`zoomTo`**(`Double` *value*): zoom to the provided value

#### Center

**`center`**: get the current center `LatLng` value

**`centerOnPoint`**(`LatLng` *point*): center on the `LatLng` value

### Map assets

#### Markers

**`addMarker`**(`String` *name*, `Marker` *marker*): add a named marker on the map

**`addMarkers`**(`Map<String, Marker>` *markers*): add several named markers on the map

**`removeMarker`**(`String` *name*, `Marker` *marker*): remove a named marker from the map

**`removeMarkers`**(`Map<String, Marker>` *markers*): remove several named markers from the map

**`markers`**: get the markers that are on the map

**`namedMarkers`**: get the markers with their names that are on the map

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

**`addLine`**(`String` *name*,
          `List<LatLng>` *points*,
          `double` *width* = 1.0,
          `Color` *color* = Colors.green,
          `bool` *isDotted* = false): add a line on the map

**`lines`**: get the lines that are on the map

#### Polygons

**`addPolygon`**(`String` *name*,
          `List<LatLng>` *points*,
          `double` *width* = 1.0,
          `Color` *color* = const Color(0xFF00FF00),
          `double` *borderWidth* = 0.0,
          `Color` *borderColor* = const Color(0xFFFFFF00)): add a polygon on the map

**`polygons`**: get the polygons that are on the map

### On ready callback

Execute some code right after the map is ready:

   ```dart
   @override
   void initState() {
      statefulMapController.onReady.then((_) {
         setState((_) =>_ready = true);
      });
      super.initState();
   }
   ```

### Changefeed

A changefeed is available: it's a stream with all state changes from the map controller. Use it to update the map when a change occurs:

   ```dart
   statefulMapController.onReady.then((_) {
       statefulMapController.changeFeed.listen((change) => setState(() {}));
      });
   }
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
         center: LatLng(48.853831, 2.348722), zoom: 11.0),
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
   Stack(children: <Widget>[
      FlutterMap(
         mapController: mapController,
         options: MapOptions(center: LatLng(48.853831, 2.348722), zoom: 11.0),
         layers: [
         statefulMapController.tileLayer,
         MarkerLayerOptions(markers: statefulMapController.markers),
         ],
      ),
      Positioned(
         top: 15.0,
         right: 15.0,
         child: TileLayersBar(controller: statefulMapController))
   ])
   ```