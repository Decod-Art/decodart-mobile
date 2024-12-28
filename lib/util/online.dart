const String host = '192.168.1.23';

/// The base URL for the host server.
const String hostName = 'http://$host:8000';

/// The base URL for the CDN (Content Delivery Network) images.
const String cdn = 'http://$host:8000/cdn_images';

/// Checks and modifies the given URL to ensure it points to the CDN if necessary.
///
/// If the [url] is null, it returns null.
/// If the [url] starts with 'http://' or 'https://', it returns the [url] as is.
/// Otherwise, it prepends the CDN base URL to the [url].
///
/// Example:
/// ```dart
/// String? imageUrl = checkUrlForCdn('image.png');
/// // imageUrl will be 'http://hostname/cdn_images/image.png'
/// ```
///
/// [url] The URL to check and modify.
///
/// Returns the modified URL pointing to the CDN, or the original URL if it already starts with 'http://' or 'https://'.
String? checkUrlForCdn(String? url) {
  if (url == null) {
    return url;
  }
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }
  return "$cdn/$url";
}