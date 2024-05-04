import 'package:flutter/material.dart';

import '../utils/auth/auth_handler.dart';
import '../utils/auth/user_profile.dart';
import './all_dialogs.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.65,
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[600]),
              accountName: Text(userProfile.user.userName),
              accountEmail: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(userProfile.user.email),
                  Text(
                      'Last SignIn: ${userProfile.user.lastSignInTime.day}-${userProfile.user.lastSignInTime.month}-${userProfile.user.lastSignInTime.year} ${userProfile.user.lastSignInTime.hour}:${userProfile.user.lastSignInTime.minute}'),
                ],
              ),
              currentAccountPicture: AspectRatio(
                aspectRatio: 1 / 1,
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: "assets/images/profile.png",
                      image: userProfile.user.photoURL),
                ),
              ),
            ),
            ListTile(
              title: Text('Browse Cloud Files'),
              trailing: Icon(
                Icons.cloud_done_rounded,
                color: Colors.blue[700],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manageCloudFiles');
              },
            ),
            ListTile(
              title: Text('Give Feedback'),
              trailing: Icon(
                Icons.feedback,
                color: Colors.blue[700],
              ),
              onTap: () {
                print('Give feedback Pressed');
                Navigator.pop(context);
                notificationDialog(
                    context, "Notification", "This will be added soon");
              },
            ),
            // ListTile(
            //   title: Text('Request a Feature'),
            //   trailing: Icon(Icons.cloud_done_rounded),
            //   onTap: () {
            //     print('Request a feature Pressed');
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              title: Text('Contact us'),
              trailing: Icon(
                Icons.contact_mail_rounded,
                color: Colors.blue[700],
              ),
              onTap: () {
                print('Contact us Pressed');
                Navigator.pop(context);
                notificationDialog(
                    context, "Notification", "This page will be added soon");
              },
            ),
            ListTile(
              title: Text('Privacy policy'),
              trailing: Icon(
                Icons.policy,
                color: Colors.blue[700],
              ),
              onTap: () {
                print('Privacy policy Pressed');
                Navigator.pop(context);
                notificationDialog(
                    context, "Notification", "This page will be added soon");
              },
            ),
            ListTile(
              title: Text('Rate this app'),
              trailing: Icon(
                Icons.rate_review_rounded,
                color: Colors.blue[700],
              ),
              onTap: () {
                print('Rate this app Pressed');
                Navigator.pop(context);
                notificationDialog(
                    context, "Notification", "This page will be added soon");
              },
            ),
            ListTile(
              title: Text('About'),
              trailing: Icon(
                Icons.info_rounded,
                color: Colors.blue[700],
              ),
              onTap: () {
                print('About Pressed');
                Navigator.pop(context);
                notificationDialog(
                    context, "Notification", "This page will be added soon");
              },
            ),
            ListTile(
              title: Text('Log Out'),
              trailing: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Warning!!!',
                        style: TextStyle(color: Colors.red),
                      ),
                      content: Text(
                          'Your all encrypted data will be lost from device and cannot be recovered if not uploaded to cloud storage'),
                      // add decrypted data by creating user name folder
                      actions: [
                        ElevatedButton(
                          child: Text("Logout (Don't Keep Decrypted Files)"),
                          onPressed: () {
                            authHandler.signOut(response: true);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Logout (Keep Decrypted Files)'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[700]),
                          ),
                          onPressed: () {
                            authHandler.signOut(response: false);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
