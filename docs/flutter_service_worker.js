'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "f60a171352d342409f0aa66909e2aba1",
"version.json": "db62ad16cd3bc5bacf8c45d7f5263447",
"index.html": "3b84c29c9b3b5d36c63509c2b81bc0cc",
"/": "3b84c29c9b3b5d36c63509c2b81bc0cc",
"main.dart.js": "25842fd48315051b1a8372b00e902d3e",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "1768f5b3c9aac5c4f49f6f9af91e31d0",
".git/config": "24aba7825b80728bb79e77bedfb3879f",
".git/objects/95/66c015fc52c407b165ae93c63081ca6c49beed": "0a27d1181ae0024583e083b5faa4d73b",
".git/objects/59/232f54a7aabb7043c1a22529a67c5fb5853793": "600da1a343f2309946d26a1ec21f37b1",
".git/objects/3e/584ed5e61b8b9507a910ddb04ea4f7160bdbda": "e6e4df2a8b4866ff97c6859812450200",
".git/objects/50/d616bcac792ca222f236ef6f0b311ea240e9d4": "ae0984598a9c467f78f81704f156f847",
".git/objects/68/dc59c3de8f4cfb3b7280c96188522c7297eafc": "0de9c94a1ba9504ad545ab0646366410",
".git/objects/9e/70a7346f0c3d7871e141262f69b989e2c66a28": "8c9653b27395e675c40b80e95614edbf",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/35/705a7a12a76bee94130709a34d5187d74603d8": "28fb7cab878845e775399a2c29dce97d",
".git/objects/33/b8fd75a2ae7acf9500ea686401a9811368abbb": "b7f584bbb1dd45cb204d22783b4214bf",
".git/objects/a4/3d55845b0fffa5641e9212524c7c16f7c65239": "6b259ed768431846b34c41db9e1d7ace",
".git/objects/ac/3ba45cfb377d33f35e78960e7734b39980fe9d": "7c941dadc7a05694f3e50d0ee22a64a5",
".git/objects/d0/23371979cf1e985205df19078051c10de0a82d": "700b71074bad7afee32068791dec7442",
".git/objects/d0/2369521fa46a448cae4d8bf5f97625c0ba8d0a": "c290dcb5401b3000ebb02157c34d0e04",
".git/objects/da/fd65422747502c19b5c74b4230282644d2169c": "d8a62caf99a372ff6c7692e143787ce3",
".git/objects/a2/ab53bbbb46a415f66e5600231e1f9e6225c64a": "f6278182deb90429bfe1bdfc5b18e1f5",
".git/objects/a5/1c99fa8ca91a5c6b49b91e69c442d2a55daefa": "8d2e30720f6c300922cc4f1c2cdc379c",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/bc/4cdab3faf01486d191e0dfdb90aedb28541829": "5962b31df60f90e7f66cd48339539b29",
".git/objects/f4/812f06469d7d3abe09953fd802069f69fea860": "9a8b602f2a056c77056fbb319ab5319b",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/c7/b6f55272d16ed554a30b24fcd03696aaf4eac9": "e2496b3863b627d2236beffd0fd9e69a",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/c8/3558a390e2803e7e5daa9b837f5ce01da28f07": "f08e707ee23f6cb1e6779ec4e0919838",
".git/objects/4e/affdadbfcf8eae5fc6c462f95a7275b1b1cd90": "474c48bf1c105a729315401eb92dd5c6",
".git/objects/45/7c8fde0f9c59af8c268fbc88e5d6a868a90dc3": "e3c364da22a25fc8152f3f88e3447a87",
".git/objects/74/7a32705e443b1c0d7904ea2be68fda2fe8e355": "4c055b4eb12c4fc7f4a3a8bf2304cec4",
".git/objects/28/0f5992fd558d6481983f1a5a8d0fd8f5868d83": "4bacc3653f5cd2f235c4c80ed9691f75",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/21/d0e4ad51a16102d013d6c6a4bad8cb219f1674": "cfa2b2179b3b7fd3fb8976ca6cbd54d5",
".git/objects/44/a8b8e41b111fcf913a963e318b98e7f6976886": "5014fdb68f6b941b7c134a717a3a2bc6",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/9f/83ddce8f22f4e7da2e5961997a721436c2d679": "60ac094b2869fe0e351140e5d16e08d0",
".git/objects/9f/18fe33700583f7b32b097334dffc82f30d0d50": "c3c45a45ab1d68b524e27d3996d0ec89",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/5d/c08569184a6bc92d880490b7ffefd305e6ba49": "53822c9c7d8211b786b2fc3e925ed6bc",
".git/objects/91/0118341282ec75891027fc65bca07792a86f4e": "5465198839595b36a4fc413993e357bf",
".git/objects/91/36d26593766ec5069c04573c7614c8810cddfc": "877fdb60cfa8082e276d7499e5616695",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/08/32d0db2def1613c1c45aa4fe9156a1c6b7d589": "e05df183e5eeaddf39672a2516f9c41d",
".git/objects/55/5516c8f1e35720d73758e41b421e0fb3eff52a": "ca86f7192d0f969935ee9c8dcb579870",
".git/objects/63/26fab815f097fbadd1c15c27058829dae7fb59": "9d5549ca1e1d06c34df41cc1d4711080",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b6/d50f763ec4a3008e0aa3a660515ec94196ecb1": "067d53dc1a3023aac08d8d6d3aa26d9f",
".git/objects/a9/dc890ee98f51ea114324535da0a9b171a5ef75": "ea8b6ee08c68bb531e9b8f01587bb1fe",
".git/objects/d5/8a3ed32a5cfa9d961bbcc98356e88812959d86": "2de799b6b8914adce681b90c7e0b036f",
".git/objects/d5/33dcbeb10ab5bf4077b4f3ae77ff0589af1866": "3bd9b1efdc40277d868030b0c2d584ab",
".git/objects/d2/728eeeb111f6d48897e62c9dfcc0fd2f3ef61b": "c53ddadcfb2e197424182fcff02cea83",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/cd/a747946534649375ea735f8e1c00224021c7b9": "afedbeca242c3fc8f9a471b053f372a9",
".git/objects/f6/75173262ebf455e4233e0c169df56e677dde0f": "ab1dfb67ffdc376076a013ee7baeff4d",
".git/objects/83/20b439e2467fb005a69563418e8a73e8360b8c": "3a39a25535cbd3ed67c802e01e1a977c",
".git/objects/1b/ec00973551821923e6f6f63f855aae1397ad9d": "399b530e7a89572cf5d32b853f180c01",
".git/objects/70/8e7dd8ae07f8e2d950f7b10cf40a8dbc9d8fc5": "48e03b9036384b4d1d55ef03769d257e",
".git/objects/1e/b8e4d42d1d35c705a099ff1dc7ef317bd43b2f": "aa52d83d40ffb5c83fd8f9e205c36c00",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/1d/fa0357fa362d90407e77fd24c6ab6e514502ad": "1439440720f3fedff332448b8a2646d5",
".git/objects/2e/5d657b528b02a54e0ae65354b3ac5d78dbde8d": "33388f2413e4fce3176e464ab751d910",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "1d7223abbf81f1544f1b9242e66bed2f",
".git/logs/refs/heads/main": "3ea1cd3f377f51b27ea620085bd71ac3",
".git/logs/refs/remotes/origin/main": "248c6e8c986f1e754fa05b515a55a4d5",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/main": "28b2555e48f914e6bd0b6fe04bbf122d",
".git/refs/remotes/origin/main": "28b2555e48f914e6bd0b6fe04bbf122d",
".git/index": "ee643270cb1a8eca8d5580fd39cf4142",
".git/COMMIT_EDITMSG": "fc19491cc2b1017aabaf6565a1c76cbd",
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
