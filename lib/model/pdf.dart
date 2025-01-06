import 'dart:async';
import 'dart:typed_data' show Uint8List;
import 'package:decodart/api/data.dart' show fetchData;
import 'package:decodart/util/online.dart' show checkUrlForCdn;
import 'package:mutex/mutex.dart' show Mutex;


class PDFOnline {
  final Mutex mutex = Mutex();
  final String _path;

  Uint8List? data;

  PDFOnline(String path, {this.data}):_path = path;

  String get path => checkUrlForCdn(_path, image: false)!;

  Future<Uint8List> downloadData({keep=true}) async {
    await mutex.acquire();
    try {
      final Uint8List data = hasData ? this.data! : await fetchData(path);
      if (!hasData && keep) {
         this.data = data;
      } else if (keep == false){
        this.data = null;
      }
      return data;
    } finally {
      mutex.release();
    }
  }

  void clearData() {
    data = null;
  }

  bool get isDownloaded => data != null;
  bool get hasData => isDownloaded;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PDFOnline) return false;
    return _path == other._path;
  }

  @override
  int get hashCode => _path.hashCode;
}
