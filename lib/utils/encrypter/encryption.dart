import 'package:aes_crypt/aes_crypt.dart';

import '../../models/file_data.dart';
import '../../file_manager/file_manager.dart';

Future<String> encryptPickedFile(List data) async {
  String encryptedFilePath;
  final FileData fileData = data[0];
  final String password = data[1];
  // print(password);
  if (await MyFileManager.initialize()) {
    String destinationPath =
        "${MyFileManager.applicationStorageEncryptedFilesDirPath}${fileData.name}.aes";
    // print(destinationPath);

    AesCrypt crypt = AesCrypt();

    crypt.setOverwriteMode(AesCryptOwMode.rename);
    // crypt.setOverwriteMode(AesCryptOwMode.warn);
    crypt.setPassword(password);
    try {
      encryptedFilePath =
          await crypt.encryptFile(fileData.path, destinationPath);
      print('The encryption has been completed successfully.');
      print('Encrypted file location: $encryptedFilePath');
    } on AesCryptException catch (e) {
      // It goes here if overwrite mode set as 'AesCryptFnMode.warn'
      // and encrypted file already exists.

      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The encryption has been completed unsuccessfully.');
        print(e.message);
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  return encryptedFilePath;
}
