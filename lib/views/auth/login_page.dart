import 'package:flutter/material.dart';

import '../../utils/auth/auth_handler.dart';
import '../../widgets/all_dialogs.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(tag: 'appLogoTag', child: FlutterLogo(size: 150)),
                    SizedBox(height: 50),
                    _signInButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.blue[700]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        final int res = await authHandler.signInWithGoogle();
        switch (res) {
          case 0:
            Navigator.pushReplacementNamed(context, '/homePage');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/introPage');
            break;
          case 2:
            setState(() {
              _isLoading = false;
            });
            notificationDialog(context, 'Error', 'Invalid Credetials');
            break;
          case 3:
            setState(() {
              _isLoading = false;
            });
            notificationDialog(
                context, 'Error', 'Your account is blocked\nContact our team');
            break;
          default:
            setState(() {
              _isLoading = false;
            });
            notificationDialog(
                context, 'Error', 'Contact our team for resolution');
            break;
        }
      },
    );
  }
}
