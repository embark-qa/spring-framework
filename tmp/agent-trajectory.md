# Search trajectory

- Ran jbcontext search for expensive class reflection and metadata lookup caches.
- Inspected CachedIntrospectionResults: static strongClassCache and softClassCache; forClass checks both before introspection and caches with putIfAbsent.
- Checked ReflectionUtils for method/field caches and CachingMetadataReaderFactory for class-file metadata caching.
- No framework source changes or tests needed for this code-location question.
