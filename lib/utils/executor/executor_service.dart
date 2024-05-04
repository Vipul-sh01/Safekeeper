import 'package:flutter/foundation.dart';

// import '../cryptors/cryptors.dart';
import '../../models/file_data.dart';
import '../encrypter/encryption.dart';
import '../decrypter/decryption.dart';

class ExecutorService {
  static Future<String> runEncryptionService(
      FileData fileData, String password) async {
    String path;
    try {
      path = await compute(encryptPickedFile, [fileData, password]);
    } on Exception catch (e) {
      print(e);
      path = null;
    }
    return path;
  }

  static Future<String> runDecryptionService(
      String fileName, String filePath, String password) async {
    String path;
    try {
      path = await compute(decryptSelectedFile, [fileName, filePath, password]);
    } on Exception catch (e) {
      print(e);
      path = null;
    }
    return path;
  }
}
