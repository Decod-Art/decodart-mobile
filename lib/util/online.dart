const String hostName = 'http://localhost:8000';
const String cdn = 'http://localhost:8000/cdn_images';

String? checkUrlForCdn(String? url) {
  if (url == null) {
    return url;
  }
  if (url.startsWith('http://')||url.startsWith('https://')) {
    return url;
  }
  return "$cdn/$url";
}