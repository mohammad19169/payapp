import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:payapp/controller/auth_controller.dart';
import 'package:payapp/core/components/print_text.dart';
import 'package:payapp/data/repository/auth_repo.dart';
import 'package:payapp/services/apis/apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/hiveConfig.dart';
import '../core/services/hiveDatabase.dart';
import '../models/usermodel.dart';
import '../util/app_constants.dart';
import '../view/base/custom_snackbar.dart';

class LoginSignUpProvider extends ChangeNotifier {
  bool? emailExists;
  bool checkingUser = false;
  bool loading = false;
  bool verifyingOTP = false;
  bool signingUp = false;
  UserModel? userModel;
  bool uploadingKycDetails = false;


  late Box box;

  Future<UserModel?> initUser() async {
    print("user model is");
      box = await HiveDataBase.openBox(boxName: HiveConfig.user);
      final user =
      await HiveDataBase.getSingleItem(key: HiveConfig.user, box: box);
      if (user != null) {
        userModel = UserModel.fromMap(user);
        updateLoggedInUser(userId: userModel?.id);
        return userModel;
    }
    else{
      return null;
    }


  }

  Future<bool> initSkip() async {
    final value =
        await HiveDataBase.getSingleItem(key: HiveConfig.skipLogin, box: box);
    if (value != null) {
      return value;
    }
    return false;
  }

  Future<bool> initOnBoarding() async {
    final value =
        await HiveDataBase.getSingleItem(key: HiveConfig.onBoarding, box: box);
    if (value != null) {
      return value;
    }
    return false;
  }

  Future<void> logOutUser() async {

     SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.setStringList(AppConstants.cartList, []);

  }

  Future<UserModel?> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try{
      loading = true;
      notifyListeners();
      final value = await ApiService.loginWithEmailAndPassword(email, password)
          .then((value) async {
        box = await HiveDataBase.openBox(boxName: HiveConfig.user);
        await box.clear();
        await HiveDataBase.saveSingleItem(
            box: box, data: value, key: HiveConfig.user);
        userModel = UserModel.fromMap(value);
        return userModel;
      }).onError((error, stackTrace) {
        loading = false;
        notifyListeners();
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 13.0);
        return Future.error(error.toString());
      });
      loading = false;
      notifyListeners();
      return value;
    }
    catch(e){
    }
    return null;


  }

  Future<UserModel?> updateLoggedInUser({required String? userId}) async {
    if (userId != null) {
      final value =
          await ApiService.fetchUserDetails(userId: userId).then((value) async {
        print("Value of update details \n$value");
        await box.clear();
        await HiveDataBase.saveSingleItem(
            box: box, data: value, key: HiveConfig.user);
        userModel = UserModel(
          id: value['id'] ?? '',
          name: value['name'] ?? '',
          email: value["email"] ?? '',
          mobile: value["mobile"] ?? '',
          kycStatus: value["kyc_status"].toString() ?? '',
          Token: value["refreshToken"].toString() ?? '',
          referCode: value["refer_code"].toString() ?? '',
          password: "",
          aadharCardNo: value["aadhar_card_no"].toString() ?? '',
          signUpMethod: value["sign_up_method"] ?? '',
          panCardNo: value["pan_card_no"].toString() ?? '',
          aadharImage: value["aadhar_img"] ?? '',
          userKycStatus: '',
          status: value["status"].toString() ?? '',
          image: "",
          dob: value["dob"].toString() ?? '',
          balance: value["balance"].toString() ?? '',
          educationType: value["is_student"]
              ? EducationType.student
              : EducationType.teacher,
          educationTypeTeacher: value["is_student"]
              ? EducationType.student
              : EducationType.teacher,
          academicStatus: '',
          competitive: value["isCompetitive"].toString() ?? '',
          panImage: value["pan_img"].toString() ?? '',
          managerId: '',
          points: value["points"].toString() ?? '',
          createdAt: "",
          isBanned: value["is_ban"].toString() ?? '',
        );
        printThis("userUpdated");
        return userModel;
      }).onError((error, stackTrace) {
        printThis("user Details Update Fail");
        return Future.error(error.toString());
      });
      return value;
    }
    return null;
  }

  Future checkUserEmail(String email) async {
    checkingUser = true;
    notifyListeners();
    await ApiService.checkUserEmail(email).then((value) async {
      emailExists = value;
      return value;
    }).onError((error, stackTrace) {
      checkingUser = false;
      notifyListeners();
      return Future.error(error.toString());
    });

    checkingUser = false;
    notifyListeners();
    return emailExists;
  }

  void clearExistingEmail() {
    emailExists = null;
    notifyListeners();
  }

  Future<void> doneOnBoarding() async {
    await HiveDataBase.saveSingleItem(
      box: box,
      data: true,
      key: HiveConfig.onBoarding,
    );
  }

  Future<void> skipLogin() async {
    await HiveDataBase.saveSingleItem(
        box: box, data: true, key: HiveConfig.skipLogin);
  }

  //old Functions

  Future verifyOTP(String email, String otp) async {
    verifyingOTP = true;
    notifyListeners();
    var result = await ApiService.verifyOTP(email, otp);
    verifyingOTP = false;
    notifyListeners();
    return result;
  }

  Future signUp(String firstName, String lastName, String email, String mobile,
      String password, String refID) async {
    signingUp = true;
    notifyListeners();
    print(email);
    print(mobile);
    var result = await ApiService.signUp(
            firstName, lastName, email, mobile, password, refID)
        .then((value) {
          print("passssssssss");
      return value;
    }).onError((error, stackTrace) {
      print("errrrrrrrrrrrrrr");
      print(error);
      signingUp = false;
      notifyListeners();

      return Future.error(error!);
    });
    signingUp = false;
    notifyListeners();
    return result;
  }

// Future loginWithGoogle() async{
//   final googleSignIn = GoogleSignIn();
//   try{
//     final googleUser = await googleSignIn.signIn();
//     if (googleUser == null)
//     {
//       loading=false;
//       notifyListeners();
//       return;
//     }
//     var status = await ApiService.checkUserGmail(googleUser.email);
//     if(status==false){
//       print("Email Already Exists");
//     }
//     else{
//       print("Sign Up New User.");
//     }
//     print(googleUser.photoUrl);
//   }
//   catch(e){
//     print(e.toString());
//   }
// }
}
