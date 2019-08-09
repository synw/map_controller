# Map controller

[![pub package](https://img.shields.io/pub/v/map_controller.svg)](https://pub.dartlang.org/packages/map_controller)

Stateful map controller for Flutter Map. Manage markers, lines and polygons.

## Api

Api for the `StatefulMapController` class

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
