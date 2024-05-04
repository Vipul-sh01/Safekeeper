import 'dart:io';

import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

import 'package:safekeeper/models/file_data.dart';
import 'package:safekeeper/utils/helpers/toast.dart';

class MyFileManager {
  static const _platform = const MethodChannel("com.safeKeeper");
  static const String applicationStorageDirPath =
      "/storage/emulated/0/SafeKeeper/";
  static const String applicationStorageEncryptedFilesDirPath =
      "/storage/emulated/0/.SafeKeeper/.encrypted/";
  static const String applicationStorageHiddenFilesDirPath =
      "/storage/emulated/0/.SafeKeeper/.hidden/";
  static Directory applicationStorageDir;
  static Directory applicationStorageEncryptedFilesDir;
  static Directory applicationStorageHiddenFilesDir;

  static Map<String, String> _encryptedFiles;

  static Map<String, String> get encryptedFiles => _encryptedFiles;

  static Future<bool> initialize() async {
    try {
      // Toast('initialize');
      applicationStorageDir =
          await Directory(applicationStorageDirPath).create(recursive: true);
      // Toast('initialize app dir');
      applicationStorageEncryptedFilesDir =
          await Directory(applicationStorageEncryptedFilesDirPath)
              .create(recursive: true);
      // Toast('initialize app enc dir');
      applicationStorageHiddenFilesDir =
          await Directory(applicationStorageHiddenFilesDirPath)
              .create(recursive: true);
      getEncryptedDirectory().listSync();
      _encryptedFiles = Map();
      _encryptedFiles = {
        for (FileSystemEntity e in getEncryptedDirectory().listSync())
          e.path.split('/').last: e.path
      };
      // getEncryptedDirectory().listSync().;
      // Toast('initialize app hid dir');
      // Toast('all initialize');
      return true;
    } on PlatformException catch (e) {
      print('Exception in initialize file manager ${e.message}');
      // Toast('platofrm exception');
      return false;
    } on Exception catch (e) {
      print(e);
      // Toast('exception');
      return false;
    }
  }

  /// open the file chooser on the [android] platform
  ///
  /// Pick single file at a time from the local storage
  ///
  /// Returns the choosed [File Name] and [File Size] (in Kb)
  static Future<FileData> pickDeviceFile() async {
    try {
      final res = await _platform.invokeMethod("openFileChooser");
      print(res);
      if (res != null) {
        final String name = res['fileName'];
        final double size = res['size'];
        // print('Size in Mb: ${size / 1000}');
        return FileData(name, null, size);
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print(e.message);
      print(e.code);
      return null;
    }
  }

  // Returns null if file loading fails
  //  else returns the path of the loaded file
  static Future<String> loadDeviceFile() async {
    String path;
    try {
      path = await _platform.invokeMethod("loadFile");
      print(path);
    } on PlatformException catch (e) {
      print(e.message);
      print(e.code);
    }
    return path;
  }

  static Future<bool> deleteOriginalFile() async {
    try {
      final bool res = await _platform.invokeMethod("deleteFile");
      return res;
    } on PlatformException catch (e) {
      print(e.message);
      print(e.code);
      return false;
    }
  }

  static Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }

  static Future<void> performCelanUp(bool response) async {
    await getEncryptedDirectory().delete(recursive: true);
    await getHiddenDirectory().delete(recursive: true);
    if (response) {
      await getDecryptedDirectory().delete(recursive: true);
    }
  }

  /// Delete the file by providing absolute [path] of the file
  ///
  /// Returns [true] if the file deletion success
  /// or returns [false] if it fails

  static Future<bool> deleteFile(String path) async {
    try {
      await File(path).delete();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  static bool doesExists(String fileName) {
    if (File('$applicationStorageEncryptedFilesDirPath/$fileName')
        .existsSync()) {
      return true;
    }
    return false;
  }

  static void refreshEncryptedFiles() {
    _encryptedFiles = Map();
    _encryptedFiles = {
      for (FileSystemEntity e in getEncryptedDirectory().listSync())
        e.path.split('/').last: e.path
    };
  }

  static Directory getEncryptedDirectory() {
    return Directory(applicationStorageEncryptedFilesDirPath);
  }

  static Directory getDecryptedDirectory() {
    return Directory(applicationStorageDirPath);
  }

  static Directory getHiddenDirectory() {
    return Directory(applicationStorageHiddenFilesDirPath);
  }
}
