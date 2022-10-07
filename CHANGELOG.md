# Changelog

## 1.0.0

### Breaking Changes

* `StatefulMapController.mutateMarker` now requires you to pass a `value` which became an `Object?`
* `StatefulMapController.onPositionChanged`'s `gesture` parameter is now a positional argument
* Migrated to `flutter_map: ^3.0.0`
* Removed `onReady` callback (not needed anymore)

### Non-breaking Changes

* `StatefulMapController.notify`'s `value` parameter is now an `Object?`
* `StatefulMarker.mutate`'s `value` parameter is now an `Object?`
* Bumped dependency `rxdart` version to `0.27.5`
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
