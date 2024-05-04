import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:safekeeper/widgets/all_dialogs.dart';

import '../utils/cloud_data_handlers/firebase_cloud_handler.dart';
import '../file_manager/file_manager.dart';

showDetails(BuildContext context, String filePath, DateTime dateTime,
    int fileSize, bool isAlreadyUploaded) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("File Details"),
          content: Builder(
            builder: (context) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: " + filePath,
                    ),
                    Divider(),
                    Text("Last Modified: " +
                        dateTime.toString().substring(
                              0,
                              dateTime.toString().lastIndexOf(':'),
                            )),
                    Divider(),
                    Text("Size: " +
                        (fileSize / 1000000).toStringAsFixed(2) +
                        "Mb"),
                    Divider(),
                    Text.rich(TextSpan(text: "Uploaded to Cloud: ", children: [
                      isAlreadyUploaded
                          ? TextSpan(
                              text: "Yes",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold))
                          : TextSpan(
                              text: "No",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold))
                    ])),
                    Divider(),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue[600],
                  ),
                ),
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop())
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      });
}

Widget buildListItem(BuildContext context, String fileName, Function onTap,
    String filePath, Function refreshFiles) {
  // print(fileName);
  // print(cloudHandler.cloudFileNames.keys.first);
  final size = MediaQuery.of(context).size;
  int index = fileName.lastIndexOf('.');
  String fileExtension, name = fileName;
  if (index != -1) {
    name = fileName.substring(0, index);
    fileExtension = fileName.split('.').last;
  }
  bool isAlreadyUploaded =
      cloudHandler.cloudFileNames.containsKey('$fileName.aes');
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 4),
              Image.asset(
                'assets/images/icons8-data-encryption-64.png',
                width: size.width * 0.06,
                height: size.height * 0.06,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                    if (fileExtension != null)
                      Text('.$fileExtension', maxLines: 1),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.lock_open_rounded),
                    onPressed: onTap,
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(
                      isAlreadyUploaded
                          ? Icons.cloud_done_rounded
                          : Icons.cloud_upload_rounded,
                      color: isAlreadyUploaded ? Colors.green : Colors.red,
                    ),
                    onPressed: () async {
                      if (!isAlreadyUploaded) {
                        firebase_storage.TaskState res = await cloudHandler
                            .uploadFile(context, '$fileName.aes');
                        if (res == firebase_storage.TaskState.error) {
                          notificationDialog(context, "Error",
                              "Some error occured while uploading");
                        } else {
                          refreshFiles();
                        }
                      }
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      final file = File(filePath);
                      showDetails(context, fileName, file.lastModifiedSync(),
                          file.lengthSync(), isAlreadyUploaded);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

////////////////////////////////////////////////////////////////////////////////
///Cloud file page
////////////////////////////////////////////////////////////////////////////////

Widget buildCloudListItem(BuildContext context, String fileName,
    firebase_storage.Reference reference, Function updateCloudFiles) {
  final size = MediaQuery.of(context).size;
  int index = fileName.lastIndexOf('.');
  String fileExtension, name = fileName;
  bool isOfflineAvailable =
      MyFileManager.encryptedFiles.containsKey('$fileName.aes');
  if (index != -1) {
    name = fileName.substring(0, index);
    fileExtension = fileName.split('.').last;
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 6),
              Icon(
                Icons.description_rounded,
                color: Colors.blue[700],
                size: size.height * 0.04,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                    if (fileExtension != null)
                      Text('.$fileExtension', maxLines: 1),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete_rounded),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          bool isPressed = false;
                          return AlertDialog(
                            title: Text(
                              'Warning!!!',
                              style: TextStyle(color: Colors.red),
                            ),
                            content:
                                Text('Are you sure to delete the backup file?'),
                            actions: [
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Yes'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue[700]),
                                ),
                                onPressed: () async {
                                  if (!isPressed) {
                                    print("Entered");
                                    isPressed = true;
                                    await reference.delete();
                                    updateCloudFiles();
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    tooltip: isOfflineAvailable
                        ? "Offline Available"
                        : "Online Available",
                    icon: Icon(
                      isOfflineAvailable
                          ? Icons.download_done_rounded
                          : Icons.cloud_download_rounded,
                      color: isOfflineAvailable ? Colors.green : Colors.red,
                    ),
                    onPressed: () async {
                      if (!isOfflineAvailable) {
                        print("Downloading can be done");
                        // Download file
                        // then update cloud files data
                        firebase_storage.TaskState res = await cloudHandler
                            .downloadFile(context, '$fileName.aes');
                        if (res == firebase_storage.TaskState.error) {
                          notificationDialog(context, "Error",
                              "Some error occured while uploading");
                        } else {
                          MyFileManager.refreshEncryptedFiles();
                          updateCloudFiles();
                        }
                      }
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      );
                      final metaData = await reference.getMetadata();
                      Navigator.of(context).pop();
                      showCloudFileDetails(
                          context, fileName, metaData, isOfflineAvailable);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

showCloudFileDetails(BuildContext context, String filePath,
    firebase_storage.FullMetadata metaData, bool isOfflineAvailable) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("File Details"),
          content: Builder(
            builder: (context) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $filePath',
                    ),
                    // Divider(),
                    // Text('Creation Time: ${metaData.timeCreated}'),
                    Divider(),
                    Text('Last Modified: ${metaData.updated}'),
                    Divider(),
                    Text(
                        'Size: ${(metaData.size / 1000000).toStringAsFixed(2)} Mb'),
                    Divider(),
                    Text('Available on device: ' +
                        (isOfflineAvailable ? "Yes" : "No")),
                    Divider(),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue[600],
                  ),
                ),
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop())
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      });
}
