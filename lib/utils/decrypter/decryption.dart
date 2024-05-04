import 'package:aes_crypt/aes_crypt.dart';

import '../../file_manager/file_manager.dart';

Future<String> decryptSelectedFile(List<String> data) async {
  String decryptedFilePath;
  final String fileName = data[0];
  final String path = data[1];
  final String password = data[2];
  if (await MyFileManager.initialize()) {
    String destinationPath =
        "${MyFileManager.applicationStorageDirPath}$fileName";
    // print(destinationPath);
    AesCrypt crypt = AesCrypt();
    crypt.setPassword(password);
    try {
      // Decrypts the file which has been just encrypted.
      // It returns a path to decrypted file.
      decryptedFilePath = await crypt.decryptFile(path, destinationPath);
      print('The decryption has been completed successfully.');
      print('Decrypted file location: $decryptedFilePath');
    } on AesCryptException catch (e) {
      // It goes here if the file naming mode set as AesCryptFnMode.warn
      // and decrypted file already exists.
      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The decryption is unsuccessfull');
        decryptedFilePath = 'null';
        print(e.message);
      }
    } on Exception catch(e){
      print('Exception occured: $e');
    }
  }
  return decryptedFilePath;
}
