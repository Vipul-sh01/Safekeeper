// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:safekeeper/file_manager/file_manager.dart';
// import '../utils/auth/user_profile.dart';

// firebase_storage.UploadTask startUpload(File file, String fileName) {
//   final firebase_storage.FirebaseStorage _storage =
//       firebase_storage.FirebaseStorage.instanceFor(
//           bucket: 'gs://safekeeper-9635e.appspot.com/');
//   String userId = userProfile.user.email;
//   userId = userId.substring(0, userId.lastIndexOf('.'));
//   String filePath = '$userId/$fileName.aes';
//   firebase_storage.UploadTask _uploadTask =
//       _storage.ref().child(filePath).putFile(file);
//   final downloadUrl = _uploadTask.snapshot.ref;
//   print(downloadUrl.toString());
//   return _uploadTask;
// }

// Future<void> downloadFile(firebase_storage.Reference ref) async {
//   final path = MyFileManager.applicationStorageDirPath;
//   final File tempFile = File('$path${ref.name}');
//   print(tempFile.path);
//   if (tempFile.existsSync()) await tempFile.delete();

//   await ref.writeToFile(tempFile);
// }
