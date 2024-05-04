import 'package:flutter/material.dart';

import './form_builder.dart';
import './custom_button.dart';

Future<String> askPasswordDialog(
    BuildContext context, bool isEncryption) async {
  final _formKey = GlobalKey<FormState>();
  String _password;
  final size = MediaQuery.of(context).size;
  return showDialog<String>(
    barrierDismissible: false,
    // useRootNavigator: true,
    context: context,
    useSafeArea: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(isEncryption
                          ? 'Please Remember Your Password Carefully'
                          : 'Please Enter Password used for Encryption'),
                    ),
                    BuildForm(
                        title: 'Password',
                        icon: Icons.lock_outline,
                        validator: (String value) {
                          if (value.length < 5) {
                            return 'Password Length must be atleast 5';
                          }
                          return null;
                        },
                        onSaved: (val) => _password = val),
                    SizedBox(height: size.height * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          disabledColor: Colors.grey,
                          height: size.height * 0.06,
                          width: size.width * 0.3,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: size.width * 0.038,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                          },
                        ),
                        CustomButton(
                          disabledColor: Colors.grey,
                          height: size.height * 0.06,
                          width: size.width * 0.3,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: size.width * 0.038,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Navigator.of(context).pop(_password);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

notificationDialog(BuildContext context, String title, String notification) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
            ),
            child: Text(
              "OK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: Text(
          notification,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    },
  );
}

customProgressDialog(BuildContext context,
    {String content = 'Loading...', double progressPercent}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                progressPercent == null
                    ? CircularProgressIndicator()
                    : LinearProgressIndicator(
                        value: progressPercent,
                      ),
                SizedBox(width: 20),
                progressPercent == null
                    ? Text(content)
                    : Text(
                        'Uploading: ${(progressPercent * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// customLinearProgressDialog(
//     BuildContext context, String content, double progressPercent) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     useRootNavigator: true,
//     builder: (BuildContext context) {
//       return WillPopScope(
//         onWillPop: () => Future.value(false),
//         child: Dialog(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 LinearProgressIndicator(
//                   value: progressPercent,
//                 ),
//                 SizedBox(width: 20),
//                 Text('${(progressPercent * 100)}%'),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
