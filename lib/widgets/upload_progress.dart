import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

String _bytesTransferred(firebase_storage.TaskSnapshot snapshot) {
  double res = snapshot.bytesTransferred / 1024.0;
  double res2 = snapshot.totalBytes / 1024.0;
  return '${res.truncate().toString()}/${res2.truncate().toString()}';
}

Future<firebase_storage.TaskState> uploadStatus(
    BuildContext context, firebase_storage.UploadTask task) async {
  final firebase_storage.TaskState result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StreamBuilder(
        stream: task.snapshotEvents,
        builder: (BuildContext context,
            AsyncSnapshot<firebase_storage.TaskSnapshot> snapshot) {
          Widget subtitle;
          double progressPercent = 0;
          Widget progressIndicator;
          if (snapshot.hasData) {
            final firebase_storage.TaskSnapshot snap = snapshot.data;
            subtitle = Text(
              '${_bytesTransferred(snap)} KB sent',
              style: TextStyle(fontWeight: FontWeight.bold),
            );
            progressPercent = snap.bytesTransferred / snap.totalBytes;
            progressIndicator = LinearProgressIndicator(
              value: progressPercent,
            );
          } else if (snapshot.hasError) {
            Navigator.of(context).pop(firebase_storage.TaskState.error);
          } else {
            subtitle = const Text('Starting...',
                style: TextStyle(fontWeight: FontWeight.bold));
            progressIndicator = CircularProgressIndicator();
          }
          if (progressPercent == 1.0) {
            // print("Upload complete");
            Future.delayed(Duration(milliseconds: 1000), () {
              Navigator.of(context).pop(firebase_storage.TaskState.success);
            });
          }
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: task.snapshot.state ==
                              firebase_storage.TaskState.success
                          ? Text(
                              "Upload Complete",
                              textScaleFactor: 1.1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          : Text(
                              "Uploading...",
                              textScaleFactor: 1.1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                    SizedBox(height: 20),
                    progressIndicator,
                    SizedBox(height: 20),
                    subtitle,
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}



Future<firebase_storage.TaskState> downloadStatus(
    BuildContext context, firebase_storage.DownloadTask task) async {
  final firebase_storage.TaskState result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StreamBuilder(
        stream: task.snapshotEvents,
        builder: (BuildContext context,
            AsyncSnapshot<firebase_storage.TaskSnapshot> snapshot) {
          Widget subtitle;
          double progressPercent = 0;
          Widget progressIndicator;
          if (snapshot.hasData) {
            final firebase_storage.TaskSnapshot snap = snapshot.data;
            subtitle = Text(
              '${_bytesTransferred(snap)} KB downloaded',
              style: TextStyle(fontWeight: FontWeight.bold),
            );
            progressPercent = snap.bytesTransferred / snap.totalBytes;
            progressIndicator = LinearProgressIndicator(
              value: progressPercent,
            );
          } else if (snapshot.hasError) {
            Navigator.of(context).pop(firebase_storage.TaskState.error);
          } else {
            subtitle = const Text('Starting...',
                style: TextStyle(fontWeight: FontWeight.bold));
            progressIndicator = CircularProgressIndicator();
          }
          if (progressPercent == 1.0) {
            // print("Download complete");
            Future.delayed(Duration(milliseconds: 1000), () {
              Navigator.of(context).pop(firebase_storage.TaskState.success);
            });
          }
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: task.snapshot.state ==
                              firebase_storage.TaskState.success
                          ? Text(
                              "Download Complete",
                              textScaleFactor: 1.1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          : Text(
                              "Downloading...",
                              textScaleFactor: 1.1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                    SizedBox(height: 20),
                    progressIndicator,
                    SizedBox(height: 20),
                    subtitle,
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}
