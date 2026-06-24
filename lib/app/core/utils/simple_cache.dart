/// Generic in-memory TTL (Time-To-Live) cache helper.
///
/// Keeps data for a specified duration. Useful to avoid double-fetching
/// on screen navigations while still allowing manual pull-to-refresh overrides.
class SimpleCache<T> {
  T? _data;
  DateTime? _cachedAt;
  final Duration ttl;

  SimpleCache({this.ttl = const Duration(minutes: 2)});

  /// Checks if the cache contains valid, non-expired data.
  bool get isValid => _data != null && _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < ttl;

  /// Retrieves the cached data, or null if expired or not set.
  T? get data => isValid ? _data : null;

  /// Stores a new value in the cache and updates the timestamp.
  void set(T value) {
    _data = value;
    _cachedAt = DateTime.now();
  }

  /// Manually clears/invalidates the cached data.
  void invalidate() {
    _data = null;
    _cachedAt = null;
  }
}
