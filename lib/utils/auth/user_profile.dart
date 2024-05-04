import '../../models/user.dart';

// Basic User Profile as we don't need that much data of user
class UserProfile {
  User _user;

  void setUser(
      {String userName,
      String email,
      DateTime lastSignInTime,
      String photoURL}) {
    _user = User(
        userName: userName ?? 'Tony Stark',
        email: email ?? 'tony@starkindustries.com',
        lastSignInTime: lastSignInTime ?? DateTime.now(),
        photoURL: photoURL ??
            'https://drive.google.com/uc?export=download&id=1hBu6cfZvlVFm3-AB8PBx2K4AZoiAXf4e');
  }

  User get user => _user;
}

final UserProfile userProfile = UserProfile();
