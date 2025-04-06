'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "e6ae7e104c608d2d1a275d07d5ac08f5",
"version.json": "db62ad16cd3bc5bacf8c45d7f5263447",
"index.html": "6c7596b9a89e78ef8c1fd139d81e8f9f",
"/": "6c7596b9a89e78ef8c1fd139d81e8f9f",
"main.dart.js": "74d75723ab263eb37b5d2c81443b9a78",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "03e180363853abf3eb8a1d9baac0c2ed",
"assets/AssetManifest.json": "c5a90e95026d70af95310c3f3d28a906",
"assets/NOTICES": "4ccf01efb1e03b90d9325caf5e69ecd8",
"assets/FontManifest.json": "ef11e584e91fdf9c149ff10d75bcc43e",
"assets/AssetManifest.bin.json": "f750da3b7814d968c5d32be34d1d8bc6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "289cf062c068a01976df5c0ff49ff225",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "ff8d5f2b5bb4329069d02483d1588f3b",
"assets/fonts/MaterialIcons-Regular.otf": "7765010d9bce7dd7999da3ab93793524",
"assets/assets/fonts/hellix/Hellix-Light.ttf": "41583ef5a451eb732de09c5ffdcb32de",
"assets/assets/fonts/hellix/Hellix-MediumItalic.ttf": "3fcaa7425e74bc8f4e380efbfbdf6f2f",
"assets/assets/fonts/hellix/Hellix-ExtraBoldItalic.ttf": "efec4a0d785929f417857ed06373c79d",
"assets/assets/fonts/hellix/Hellix-Bold.ttf": "d681b20cf7c3b48f18605cf8d6c2d488",
"assets/assets/fonts/hellix/Hellix-RegularItalic.ttf": "68b057986673021a266fbc15925f1a7f",
"assets/assets/fonts/hellix/Hellix-Thin.ttf": "8251efe5347ad1977372e293d40d0693",
"assets/assets/fonts/hellix/Hellix-BoldItalic.ttf": "6cd7fa33543c6f356dbd444a96bcfedc",
"assets/assets/fonts/hellix/Hellix-LightItalic.ttf": "a92514637875799f14bffb1f447c308e",
"assets/assets/fonts/hellix/Hellix-Medium.ttf": "28cbb504b6722b8a6daa9dce3f47f38f",
"assets/assets/fonts/hellix/Hellix-ThinItalic.ttf": "72d01a20e4ae3da834835cabbe172fd1",
"assets/assets/fonts/hellix/Hellix-SemiBold.ttf": "8882578d9e8cd4574c1937b8fcbd45f6",
"assets/assets/fonts/hellix/Hellix-SemiBoldItalic.ttf": "2ea92cebabc6ec18e2c38fdad943215c",
"assets/assets/fonts/hellix/Hellix-Black.ttf": "88e9f07149e22679976aad4e11ffeaa6",
"assets/assets/fonts/hellix/Hellix-BlackItalic.ttf": "456cd612c9adc2afc95c769ac02a483c",
"assets/assets/fonts/hellix/Hellix-ExtraBold.ttf": "cc42f27dc0d4356cab7334456659c2f5",
"assets/assets/fonts/hellix/Hellix-Regular.ttf": "d85cb389bedbb5932823b49ef3bc5978",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
