'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/manifest.json": "00e0b69b49487ce4f9ff0c5fac8fda49",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/LICENSE": "a4eb54c746aafac2c7f8912ac3d83067",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "9a62a954b81a1ad45a58b9bcea89b50b",
"/assets/AssetManifest.json": "eb23876546ddb8d3228c733ee46373ff",
"/assets/assets/airports.geojson": "48e7a2533b6f8c0d7c8290680ba93eb3",
"/assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"/index.html": "926cd8008bef60a4e735ba8d18fbac9c",
"/main.dart.js": "80d9a09aa7ce7fdf904af36e85ab8b1f",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/favicon.png": "5dcef449791fa27946b3d35ad8803796"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
