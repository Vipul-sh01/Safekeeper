import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../file_manager/file_manager.dart';
import '../../widgets/custom_stream_builder.dart';
import '../../widgets/upload_progress.dart';

class CloudHandler {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.Reference _ref;
  set bucket(String userIdDir) =>
      _ref = firebase_storage.FirebaseStorage.instance.ref('/$userIdDir');

  List<firebase_storage.Reference> _cloudFiles;
  Map<String, bool> _cloudFileNames;

  get cloudFiles => _cloudFiles;
  Map<String, bool> get cloudFileNames => _cloudFileNames;

  Future<void> getFiles() async {
    _cloudFiles = (await _ref.listAll()).items;
    _cloudFileNames = Map();
    _cloudFiles.forEach((element) {
      _cloudFileNames.putIfAbsent(element.name, () => true);
    });
  }

  Future<firebase_storage.TaskState> uploadFile(
      context, String fileName) async {
    print(fileName);
    firebase_storage.TaskState result;
    File file = File(
        '${MyFileManager.applicationStorageEncryptedFilesDirPath}$fileName');
    final firebase_storage.UploadTask uploadTask =
        _ref.child(fileName).putFile(file);
    if (uploadTask != null) {
      // await customStreamBuilder(uploadTask, context);
      result = await uploadStatus(context, uploadTask);
      // print(result.toString());
    }
    return result;
  }

  Future<firebase_storage.TaskState> downloadFile(context, String name) async {
    print(name);
    File file =
        File('${MyFileManager.applicationStorageEncryptedFilesDirPath}$name');
    final firebase_storage.DownloadTask downloadTask =
        _ref.child('$name').writeToFile(file);
    firebase_storage.TaskState result;

    if (downloadTask != null) {
      // customStreamBuilder(downloadTask, context);
      result = await downloadStatus(context, downloadTask);
    }
    return result;
  }
}

final CloudHandler cloudHandler = CloudHandler();
