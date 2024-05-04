import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './views/home_page.dart';
import './views/auth/login_page.dart';
import './views/intros/intro_page.dart';
import './views/errors/failure_page.dart';
import './views/splash_screen/splash_screen.dart';
import './views/manage_cloud_files.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'SafeKeeper',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreen(),
        '/loginPage': (context) => LoginPage(),
        '/introPage': (context) => IntroPage(),
        '/homePage': (context) => HomePage(),
        '/errorPage': (context) => Failure(),
        '/manageCloudFiles': (context) => ManageCloudFiles()
      },
    );
  }
}
