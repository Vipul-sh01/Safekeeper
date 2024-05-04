import 'package:flutter/material.dart';

// Here intro related to the new user will be added

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dummy Intro page')),
      body: Center(
        child: Column(
          children: [
            Text(
                'Please select the non-important files for testing as if the app is operated miscorrectly then data loss can occur'),
            SizedBox(height: 10),
            RaisedButton(
                child: Text('Click Here'),
                color: Colors.blue,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/homePage')),
          ],
        ),
      ),
    );
  }
}
