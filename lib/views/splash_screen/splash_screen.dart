import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import '../../utils/cloud_data_handlers/firebase_cloud_handler.dart';
import '../../utils/auth/auth_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 500), () async {
        await Firebase.initializeApp();

        await authHandler.userReload();

        if (authHandler.getCurrentUser() != null) {
          await cloudHandler.getFiles();
          Navigator.pushReplacementNamed(context, '/homePage');
        } else {
          Navigator.pushReplacementNamed(context, '/loginPage');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          SizedBox(height: 60),
          Center(
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 70),
          Hero(tag: 'appLogoTag', child: FlutterLogo(size: 100)),
        ],
      ),
    );
  }
}
