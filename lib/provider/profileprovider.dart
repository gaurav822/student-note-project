import 'package:flutter/cupertino.dart';
import 'package:student_notes/Models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel userModel;
  int freeCourses, premiumCourses;
  String accessToken;
  String refreshToken;
  String profileImage;
  String email;
  String userName;
  bool isProfileUpdated = false;

  int getFreeCount() => freeCourses;
  int getpremiumCount() => premiumCourses;
  String getProfileImage() => profileImage;
  String getAccessToken() => accessToken;
  String getRefreshToken() => refreshToken;
  String getUname() => userName;
  String getEmail() => email;

  bool getProfileUpdateStatus() => isProfileUpdated;

  UserModel getUserProfile() => userModel;

  void setProfileStatus() {
    this.isProfileUpdated = true;
    notifyListeners();
  }

  void tokenSet(
      {String access, String refresh, String email, String username}) {
    this.accessToken = access;
    this.refreshToken = refresh;
    this.email = email;
    this.userName = username;
    notifyListeners();
  }

  void setAccess(String access) {
    this.accessToken = access;
    notifyListeners();
  }

  void setUserProfile(UserModel currModel) {
    userModel = currModel;
    notifyListeners();
  }

  void setmyCourses(int free, int premium) {
    this.freeCourses = free;
    this.premiumCourses = premium;
    notifyListeners();
  }

  void setProfileImage(String imageUrl) {
    this.profileImage = imageUrl;
    notifyListeners();
  }

  void updateUserProfile(
      {String name,
      String phone,
      String dob,
      String institute,
      String address,
      String courseName,
      String studyLevel}) {
    this.userModel.name = name;
    this.userModel.phoneNumber = phone;
    this.userModel.dob = dob;
    this.userModel.institute = institute;
    this.userModel.address = address;
    this.userModel.courseName = courseName;
    this.userModel.level = studyLevel;
    notifyListeners();
  }
}
