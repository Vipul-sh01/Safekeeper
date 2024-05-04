import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safekeeper/utils/cloud_data_handlers/firebase_cloud_handler.dart';

import '../models/file_data.dart';
import '../widgets/my_drawer.dart';
import '../utils/helpers/toast.dart';
import '../widgets/all_dialogs.dart';
import '../widgets/listing_card.dart';
import '../file_manager/file_manager.dart';
import '../utils/executor/executor_service.dart';
import '../utils/permisson_manager/permission_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  FileData _fileData;
  DateTime oldTime;
  // List<FileSystemEntity> _encryptedFiles = [];
  // bool _isfileListLoading = false;
  // List<FileSystemEntity> _hiddenFiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool status = await permissionChecker();
      // print((await getTemporaryDirectory()).absolute);

      if (status) {
        MyFileManager.refreshEncryptedFiles();
        // _hiddenFiles = MyFileManager.getHiddenDirectory().listSync();
        setState(() {
          _isLoading = false;
        });
      } else {
        Navigator.pushReplacementNamed(context, '/errorPage');
      }
    });
  }

  Future<void> _refreshCloudFiles() async {
    await cloudHandler.getFiles();
    setState(() {});
  }

  Future<void> _refreshEncryptedFiles() async {
    setState(() {
      MyFileManager.refreshEncryptedFiles();
      // _hiddenFiles =
      //     MyFileManager.getHiddenDirectory().listSync();
    });
  }

  void decrypt(String fileName, String filePath) async {
    final password = await askPasswordDialog(context, false);
    if (password == null) return;
    customProgressDialog(context, content: 'Decryption in progress...');
    final path = await ExecutorService.runDecryptionService(
        fileName, filePath, password);
    if (path != null && path != 'null') {
      if (await MyFileManager.deleteFile(filePath)) {
        Navigator.of(context).pop();
        notificationDialog(context, 'Decryption result',
            'File Decrypted Successfully!! and stored at: $path');
        setState(() {
          MyFileManager.refreshEncryptedFiles();
          // _hiddenFiles =
          //     MyFileManager.getHiddenDirectory().listSync();
        });
      } else {
        await MyFileManager.deleteFile(path);
        Navigator.of(context).pop();
        notificationDialog(context, 'Decryption result',
            'Some error has occured!! Try again or Contact support team.\nError code xD0c');
      }
    } else if (path == 'null') {
      Navigator.of(context).pop();
      notificationDialog(context, 'Decryption result',
          'A same file already exists in\ninternal storage -> Safekeeper\nDelete the old file manually and try again.\nError code xD0b');
    } else {
      Navigator.of(context).pop();
      notificationDialog(context, 'Decryption result',
          'Either Password is wrong or file is Corrupted!! Try again.\nError code xD0a');
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (oldTime == null || now.difference(oldTime) > Duration(seconds: 2)) {
      oldTime = now;
      Toast('Press again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SafeKeeper'),
        backgroundColor: Colors.blue[700],
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.file_copy),
        //       onPressed: () {
        //         List<FileSystemEntity> _decryptedFiles =
        //             MyFileManager.getDecryptedDirectory().listSync();
        //         showDialog(
        //           context: context,
        //           builder: (context) {
        //             return Dialog(
        //               child: _decryptedFiles.length > 0
        //                   ? ListView.builder(
        //                       shrinkWrap: true,
        //                       itemBuilder: (context, index) {
        //                         final fileName =
        //                             _decryptedFiles[index].path.split('/').last;
        //                         return Card(
        //                           child: ListTile(
        //                             title: Text(fileName),
        //                           ),
        //                         );
        //                       },
        //                       itemCount: _decryptedFiles.length,
        //                     )
        //                   : Card(
        //                       child: ListTile(
        //                         title: Text('No files found!!!'),
        //                       ),
        //                     ),
        //             );
        //           },
        //         );
        //       }),
        //   _isfileListLoading
        //       ? Center(
        //           child: CircularProgressIndicator(
        //             backgroundColor: Colors.white,
        //           ),
        //         )
        //       : IconButton(
        //           icon: Icon(Icons.cloud_done),
        //           onPressed: () async {
        //             setState(() {
        //               _isfileListLoading = true;
        //             });
        //             List<String> cloudFiles =
        //                 await cloudHandler.getFiles().whenComplete(() {
        //               setState(() {
        //                 _isfileListLoading = false;
        //               });
        //             });
        //             showDialog(
        //               context: context,
        //               builder: (context) {
        //                 return Dialog(
        //                   child: cloudFiles.length > 0
        //                       ? ListView.builder(
        //                           shrinkWrap: true,
        //                           itemBuilder: (context, index) {
        //                             final fileName = cloudFiles[index]
        //                                 .substring(0,
        //                                     cloudFiles[index].lastIndexOf('.'));
        //                             return Card(
        //                               child: ListTile(
        //                                 title: Text(fileName),
        //                                 onTap: () {
        //                                   cloudHandler.downloadFile(
        //                                       context, cloudFiles[index]);
        //                                 },
        //                               ),
        //                             );
        //                           },
        //                           itemCount: cloudFiles.length,
        //                         )
        //                       : Card(
        //                           child: ListTile(
        //                             title: Text('No files found!!!'),
        //                           ),
        //                         ),
        //                 );
        //               },
        //             );
        //           }),
        // ],
      ),
      drawer: MyDrawer(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
          child: RefreshIndicator(
            onRefresh: _refreshEncryptedFiles,
            color: Colors.white,
            backgroundColor: Colors.blue[600],
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemBuilder: (context, index) {
                      String fileName =
                          MyFileManager.encryptedFiles.keys.elementAt(index);
                      String filePath = MyFileManager.encryptedFiles[fileName];
                      fileName =
                          fileName.substring(0, fileName.lastIndexOf('.'));
                      return buildListItem(
                          context,
                          fileName,
                          () => decrypt(fileName, filePath),
                          filePath,
                          _refreshCloudFiles);
                    },
                    itemCount: MyFileManager.encryptedFiles.length,
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'homePageFAB',
        label: Text('Encrypt'),
        icon: Icon(Icons.lock_outline),
        tooltip: 'Select File',
        onPressed: () async {
          _fileData = await MyFileManager.pickDeviceFile();

          // Check for size restrictions here before loading (30 Mb max)
          if (_fileData != null && _fileData.size <= 31000) {
            print(
                "File Loading!!! The file: ${_fileData.name} of size: ${(_fileData.size / 1000).toStringAsFixed(2)} Mb is loading...");
            customProgressDialog(context, content: 'File is loading...');
            final path = await MyFileManager.loadDeviceFile();
            _fileData.path = path;
            Navigator.of(context).pop();
            // print(
            //     'File Loaded Successfuly: ${_fileData.path} of size: ${(_fileData.size / 1000).toStringAsFixed(2)} Mb');
            if (path != null) {
              final password = await askPasswordDialog(context, true);

              print('Entered password: $password');

              await Future.delayed(Duration(milliseconds: 20));

              if (password != null) {
                customProgressDialog(context,
                    content: 'Encryption in progress...');
                final encryptedPath =
                    await ExecutorService.runEncryptionService(
                        _fileData, password);
                Navigator.of(context).pop();
                if (encryptedPath != null) {
                  // Warning!!! Deletion is Enabled, Be safe
                  // print("path is: " + encryptedPath);
                  final deletionStatus =
                      await MyFileManager.deleteOriginalFile();
                  if (deletionStatus) {
                    notificationDialog(context, 'Encryption result',
                        'File encrypted Successfully!!');
                    setState(() {
                      MyFileManager.refreshEncryptedFiles();
                      // _hiddenFiles =
                      //     MyFileManager.getHiddenDirectory().listSync();
                    });
                  } else {
                    //   // delete the encrypted file
                    final status = MyFileManager.deleteFile(encryptedPath);
                    print('Deletion status is: $status');
                    notificationDialog(context, 'Encryption result',
                        'Some error has occured!! Try again or Contact support team.\nError code xE0d');
                  }
                } else {
                  notificationDialog(context, 'Encryption result',
                      'Some error has occured!! Try again or Contact support team.\nError code xE0c');
                }
              }
            } else {
              notificationDialog(context, 'Encryption result',
                  'Some error has occured!! Try again or Contact support team.\nError code xE0b');
            }
          } else if (_fileData.size > 31001) {
            notificationDialog(context, 'File Size exceeded!!',
                'Please choose file of size less than 30 Mb');
          } else {
            notificationDialog(context, 'Encryption result',
                'Some error has occured!! Try again or Contact support team.\nError code xE0a');
          }
          await MyFileManager.deleteCacheDir();
          // print("Cache cleared");
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
