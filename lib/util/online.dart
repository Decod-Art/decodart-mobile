const String hostName = 'http://192.168.1.16:8000';
const String cdn = 'http://192.168.1.16:8000/cdn_images';

String? checkUrlForCdn(String? url) {
  if (url == null) {
    return url;
  }
  if (url.startsWith('http://')||url.startsWith('https://')) {
    return url;
  }
  return "$cdn/$url";
}