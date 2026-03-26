const CACHE = 'fas-v1';
const ASSETS = [
  '/fas-app/',
  '/fas-app/index.html'
];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE).then(cache => cache.addAll(ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  // For API calls always go to network
  if(e.request.url.includes('api.anthropic.com') ||
     e.request.url.includes('api.openai.com') ||
     e.request.url.includes('supabase.co')) {
    return;
  }
  e.respondWith(
    fetch(e.request).catch(() => caches.match(e.request))
  );
});
