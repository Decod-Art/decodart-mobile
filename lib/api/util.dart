const String hostName = 'http://192.168.1.20:8000'; //'http://192.168.1.20:8000';
const String cdn = 'http://192.168.1.20:8000/cdn_images';//'http://192.168.1.20:8000/cdn_images';

String? checkUrlForCdn(String? url) {
  if (url == null) {
    return url;
  }
  if (url.startsWith('http://')||url.startsWith('https://')) {
    return url;
  }
  return "$cdn/$url";
}