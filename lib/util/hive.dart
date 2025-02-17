import 'package:hive/hive.dart';

/// A service class for managing Hive boxes.
class HiveService {
  static final HiveService _instance = HiveService._internal();

  /// Factory constructor to return the singleton instance of [HiveService].
  factory HiveService() => _instance;

  HiveService._internal();

  final Map<String, BoxService> _boxes = {};

  /// Opens a Hive box with the specified [boxName].
  ///
  /// If the box is already open, it increments the reference count and returns the existing box.
  /// Otherwise, it opens a new box and stores it in the [_boxes] map.
  ///
  /// Returns a [Box] of type [T].
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

  /// Closes the Hive box with the specified [boxName].
  ///
  /// If the box is open, it decrements the reference count and closes the box if the count reaches zero.
  /// Removes the box from the [_boxes] map if it is closed.
  Future<void> closeBox(String boxName) async {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      await _boxes[boxName]!.closeBox();
      // Remove the box from the map if it is closed
      if (_boxes[boxName]!.isClose) {
        _boxes.remove(boxName);
      }
    }
  }

  /// Returns the Hive box with the specified [boxName] if it is open.
  ///
  /// Returns a [Box] of type [T] or null if the box is not open.
  Box<T>? getBox<T>(String boxName) {
    if (_boxes.containsKey(boxName) && _boxes[boxName]!.isOpen) {
      return _boxes[boxName]?.box as Box<T>?;
    }
    return null;
  }

  /// Checks if the Hive box with the specified [boxName] is open.
  ///
  /// Returns true if the box is open, false otherwise.
  bool isBoxOpened(String boxName) {
    return _boxes.containsKey(boxName) && _boxes[boxName]!.isOpen;
  }

  /// Returns a list of names of all open Hive boxes.
  List<String> getOpenBoxNames() {
    return _boxes.keys.toList();
  }
}

/// A service class for managing a single Hive box with reference counting.
/// When the reference reaches 0, the box get closed
class BoxService<T> {
  int referenceCount = 0;
  Box<T>? _box;

  BoxService();

  /// Opens the Hive box with the specified [boxName].
  ///
  /// If the box is already open, it increments the reference count and returns the existing box.
  /// Otherwise, it opens a new box and sets it to [_box].
  ///
  /// Returns a [Box] of type [T].
  Future<Box<T>> openBox([String? boxName]) async {
    referenceCount++;
    if (_box != null && _box!.isOpen) {
      return _box!;
    } else {
      Box<T> box = await Hive.openBox<T>(boxName!);
      _box = box;
      return box;
    }
  }

  /// Checks if the Hive box is open.
  ///
  /// Returns true if the box is open, false otherwise.
  bool get isOpen => _box != null && _box!.isOpen;

  /// Checks if the Hive box is closed.
  ///
  /// Returns true if the box is closed, false otherwise.
  bool get isClose => !isOpen;

  /// Closes the Hive box.
  ///
  /// Decrements the reference count and closes the box if the count reaches zero.
  Future<void> closeBox() async {
    referenceCount--;
    if (referenceCount == 0) {
      await _box!.close();
      _box = null;
    }
  }

  /// Returns the Hive box.
  ///
  /// Throws an exception if the box is not open.
  Box<T> get box => _box!;
}
