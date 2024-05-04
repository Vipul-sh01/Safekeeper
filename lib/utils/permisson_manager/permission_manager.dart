import 'package:permission_handler/permission_handler.dart';

import '../../file_manager/file_manager.dart';

Future<bool> permissionChecker() async {
  bool status = false;
  if (await Permission.storage.request().isGranted) {
    status = true;
    await MyFileManager.initialize();
  }
  return status;
}
