import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import './user_profile.dart';
import '../../file_manager/file_manager.dart';
import '../cloud_data_handlers/firebase_cloud_handler.dart';

class Auth {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  firebase_auth.User _user;

  Future<int> signInWithGoogle() async {
    int res = 0;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      firebase_auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);

      if (authResult.additionalUserInfo.isNewUser) {
        res = 1;
      }
      _user = authResult.user;
      userProfile.setUser(
          userName: _user.displayName,
          email: _user.email,
          photoURL: _user.photoURL ?? null,
          lastSignInTime: _user.metadata.lastSignInTime ?? null);
      if (_user.email != null) {
        cloudHandler.bucket =
            _user.email.substring(0, _user.email.lastIndexOf('.'));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          res = 2;
          break;
        case 'user-disabled':
          res = 3;
          break;
        default:
          res = 4;
          break;
      }
    } on Exception catch (e) {
      print(e);
      // print(e.code);
      // print(e.message);
      res = 4;
    }
    return res;
  }

  firebase_auth.User getCurrentUser() {
    try {
      _user = _auth.currentUser;
      userProfile.setUser(
          userName: _user.displayName,
          email: _user.email,
          photoURL: _user.photoURL ?? null,
          lastSignInTime: _user.metadata.lastSignInTime ?? null);
      if (_user.email != null) {
        cloudHandler.bucket =
            _user.email.substring(0, _user.email.lastIndexOf('.'));
      }
    } catch (e) {
      _user = null;
      print('authHandler: error in currentUser $e');
    }
    return _user;
  }

  Future<void> userReload() async {
    try {
      _user = _auth.currentUser;
      await _user.reload();
      _user = _auth.currentUser;
    } catch (e) {
      print("authHandler: Error in userReload $e");
      _user = null;
    }
  }

  void signOut({bool response = false}) async {
    await MyFileManager.performCelanUp(response);
    await _googleSignIn?.signOut();
    await _auth?.signOut();
  }
}

final Auth authHandler = Auth();
