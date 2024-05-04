// import 'package:flutter/material.dart';

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart' as firebase_core;
// import 'package:safekeeper/widgets/all_dialogs.dart';

// import '../utils/helpers/toast.dart';

// Future<String> customStreamBuilder(firebase_storage.Task task, BuildContext context) async {
//   String taskType = 'Uploading';
//   if (task is firebase_storage.DownloadTask) {
//     taskType = 'Downloading';
//   }
//   final result = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         bool isDone = false;
//         return StreamBuilder<firebase_storage.TaskSnapshot>(
//             stream: task.snapshotEvents,
//             builder: (BuildContext context,
//                 AsyncSnapshot<firebase_storage.TaskSnapshot> asyncSnapshot) {
//               Widget text = Text('');
//               Widget progress = CircularProgressIndicator();
//               Widget button = Text('');
//               firebase_storage.TaskSnapshot snapshot = asyncSnapshot.data;
//               firebase_storage.TaskState state = snapshot?.state;
//               double progressPercent = snapshot != null
//                   ? snapshot.bytesTransferred / snapshot.totalBytes
//                   : 0;
//               if (progressPercent == 1.0) {
//                 // Navigator.of(context).pop('success');
//                 isDone = true;
//                 Toast('$taskType is done Successfully!');
//               }
//               if (asyncSnapshot.hasError) {
//                 if (asyncSnapshot.error is firebase_core.FirebaseException &&
//                     (asyncSnapshot.error as firebase_core.FirebaseException)
//                             .code ==
//                         'canceled') {
//                   print('canceled!');
//                   // Navigator.of(context).pop();
//                   // Toast('$taskType canceled');

//                   // return null;
//                 } else {
//                   // Toast('Some error occured!! Try Again');
//                   print('canceled!');
//                   Navigator.of(context).pop('error');
//                   // return null;
//                 }
//               } else if (snapshot != null) {
//                 text = Text(
//                     '$taskType: ${(progressPercent * 100).toStringAsFixed(0)}%');
//                 progress = LinearProgressIndicator(
//                   value: progressPercent,
//                 );
//                 button = TextButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(
//                         Theme.of(context).primaryColor),
//                   ),
//                   child: Text(
//                     "Cancel",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   onPressed: () async {
//                     // Navigator.of(context).pop();
//                     await task.cancel().whenComplete(() {
//                       Future.delayed(
//                         Duration(milliseconds: 500),
//                       ).whenComplete(() {
//                         Navigator.of(context).pop('canceled');
//                         return Toast('$taskType canceled!!');
//                       });
//                     });
//                     text = Text('Cancelling...');
//                     progress = CircularProgressIndicator();
//                     button = Text('');
//                   },
//                 );
//               }
//               return WillPopScope(
//                 onWillPop: () => Future.value(false),
//                 child: Dialog(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('File is $taskType'),
//                         SizedBox(height: 20),
//                         progress,
//                         SizedBox(height: 20),
//                         text,
//                         isDone
//                             ? TextButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all(
//                                       Theme.of(context).primaryColor),
//                                 ),
//                                 child: Text(
//                                   "Done",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 onPressed: () =>
//                                     Navigator.of(context).pop('success'),
//                               )
//                             : button,
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             });
//       });
//   print(result);
//   return result;
// }
