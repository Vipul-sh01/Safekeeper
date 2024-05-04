import 'package:flutter/material.dart';

class Failure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('App can not run without all permissions'),
      ),
    );
  }
}
