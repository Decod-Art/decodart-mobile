import 'package:hive/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  final Map<String, BoxService> _boxes = {};

  Future<Box<T>> openBox<T>(String boxName) async {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      _boxes[boxName]!.openBox();
      return _boxes[boxName]!.box as Box<T>;
    } else {
      BoxService<T> box = BoxService();
      await box.openBox(boxName);
      _boxes[boxName] = box;
      return box.box;
    }
  }

  Future<void> closeBox(String boxName) async {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      await _boxes[boxName]!.closeBox();
      // closed if reference count get to 0
      if (_boxes[boxName]!.isClose) {
        _boxes.remove(boxName);
      }
    }
  }

  Box<T>? getBox<T>(String boxName) {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]?.box as Box<T>?;
    }
    return null as Box<T>?;
  }

  bool isBoxOpened(String boxName) {
    return _boxes.containsKey(boxName) && _boxes[boxName]!.isOpen;
  }

  List<String> getOpenBoxNames() {
    return _boxes.keys.toList();
  }
}

class BoxService<T>{
  int referenceCount = 0;
  Box<T>? _box;
  
  BoxService();
  
  Future<Box<T>> openBox([String? boxName]) async {
    referenceCount ++;
    if (_box != null && _box!.isOpen) {
      return _box!;
    } else {
      Box<T> box = await Hive.openBox<T>(boxName!);
      _box = box;
      return box;
    }
  }

  bool get isOpen => _box != null && _box!.isOpen;

  bool get isClose => !isOpen;

  Future<void> closeBox() async {
    referenceCount --;
    if (referenceCount == 0) {
      await _box!.close();
      _box = null;
    }
  }

  // should only be called when the box has been opened
  Box<T> get box => _box!;
}