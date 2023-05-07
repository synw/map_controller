# Changelog

## 3.0.0

* Updated to [flutter_map](https://pub.dev/packages/flutter_map) v4

## 3.0.0-dev.4

* Fixed Polygon and multipolygon name issue

## 3.0.0-dev.3

* Throw a `MarkerException` if a named marker is not found

### Breaking Changes

* Removed `NotImplementedException` class (use `UnimplementedError` instead)

## 3.0.0-dev.2

* Updated `README.md` to reflect the new API
* Exposed `exceptions.dart` file
* Fixed [#3](https://github.com/TesteurManiak/map_controller_plus/issues/3)

## 3.0.0-dev.1

* Removed [rxdart](https://pub.dev/packages/rxdart) dependency
* Cleaned and simplified the code of the package (check the breaking changes for more details)

### Breaking Changes

* Removed `TileLayerType` enum
* Removed `TileLayersBar`, `MapTileLayerNormal`, `MapTileLayerMonochrome`, `MapTileLayerTopography`, `MapTileLayerHike`, `MapTileLayerCustom` widget
* Removed `TileLayerState` class
* Removed `StatefulMapController.tileLayerType` property
* Removed `StatefulMapController.customTileLayer` property
* Removed `StatefulMapController.tileLayer` property
* Removed `StatefulMapController.switchTileLayer` method

## 2.0.0

### Breaking Changes

* Migrated to `flutter_map: ^3.0.0`
* Bumped Dart sdk min version to `2.18.0`
* Removed `onReady` callback (not needed anymore)

### Non-breaking Changes

* Bumped dependency `rxdart` version to `0.27.5`

## 1.0.0

### Breaking Changes

* `StatefulMapController.mutateMarker` now requires you to pass a `value` which became an `Object?`
* `StatefulMapController.onPositionChanged`'s `gesture` parameter is now a positional argument

### Non-breaking Changes

* `StatefulMapController.notify`'s `value` parameter is now an `Object?`
* `StatefulMarker.mutate`'s `value` parameter is now an `Object?`
* Bumped dependency `rxdart` version to `0.27.4`
* Bumped dev_dependency `flutter_lints` version to `2.0.1`
* Bumped Dart sdk min version to `2.18.0`
* Replaced dev_dependency `mockito` by `mocktail`

## 0.13.1

* Prevent `markers` number from increasing

## 0.13.0

* Changed `flutter_map` dependency to `">=0.13.1 <0.15.0"`
* Upgrade `latlong2` dependency to `^0.8.1`
* Added method `removeLines`
* Putted back GeoJson features with the `geojson` package now that it is nullsafe
* Updated example and fixed some issues with the nullsafety migration
* Added unit tests

## 0.12.0-nullsafe

* Added nullsafety support
* Changed rxdart dependency to `>=0.26.0 <0.28.0`

## 0.11.0

* Upgrade `flutter_map` dependency to `^0.13.1`
* Upgrade `geopoint` dependency to `^1.0.0`
* Removed support for GeoJson as the package `geojson` does not support nullsafety

## 0.10.0

* Upgrade `flutter_map` dependency to `^0.12.0`
* Upgrade `geojson` dependency to `^0.10.0`
* Upgrade `geopoint` dependency to `^0.8.0`
* Fixed some warnings

## 0.9.0

* Upgrade `flutter_map` dependency to `^0.11.0`
* Upgrade `extra_pedantic` dependency to `^1.2.0`
* Upgrade `rxdart` dependency to `0.25.0`
* Added `meta: any` dependency
* Made some Android migration

## 0.8.3

* Added methods `addPolyline` to `StatefulMapController`

## 0.8.2

* Added methods `getLine` and `getLines` to `StatefulMapController`

## 0.8.1+1

* Upgrade flutter_map dependency to 0.10.1+1

## 0.8.1

* Fork of the original [map_controller](https://pub.dev/packages/map_controller/versions/0.8.0) lib
* Added methods `getMarker` and `getMarkers` to `StatefulMapController`
