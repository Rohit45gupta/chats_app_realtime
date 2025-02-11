
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';
import '../view/LoginPage.dart';
import '../view/get_device_token.dart';
import '../view/home_screen.dart';

class UserViewModel with ChangeNotifier{
  final  auth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool isLoading = true;
  var nameController= TextEditingController();
  var emailController= TextEditingController();
  var passwordController= TextEditingController();

  List<UserModel> _userData= [];
  List<UserModel> get userData=> _userData;

  UserModel? _currentUser;

  UserModel? get currentuser => _currentUser;

  // SignUp code//

  userSignUp(BuildContext context) async {
    var name =  nameController.text.toString();
    var email = emailController.text.toString();
    var password= passwordController.text.toString();

    if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty){
      isLoading = true;
      notifyListeners();

      DeviceTokenService().storeDeviceToken();

      try{
        var result = await auth.createUserWithEmailAndPassword(email: email, password: password);

        if(result.user!= null){
          var uid = result.user?.uid;
          DatabaseReference ref= FirebaseDatabase.instance.ref("user/$uid");
          await ref.set({
            "id":uid,
            "name":name,
            "email":email,
          });
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          Fluttertoast.showToast(msg: "SignUp is successful");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(uid: uid!,),));
        }
        notifyListeners();
      }
      catch(e){
        Fluttertoast.showToast(msg: "$e SignUp is Failed");
      }finally{
        isLoading = false;
        notifyListeners();
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please fill the all field");
    }
  }

  // userLogin//
  void userLogin(BuildContext context) async{
    var email= emailController.text;
    var password= passwordController.text;

    if(email.isNotEmpty && password.isNotEmpty){
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      if(result.user!=null){
        var uid = result.user?.uid;
        Fluttertoast.showToast(msg: "Login is Successfully");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(uid: uid!,),));

        emailController.clear();
        passwordController.clear();
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please fill the all filed");
    }
  }

  // logout user//
  void logoutUser(BuildContext context) async{
    await auth.signOut();
    Fluttertoast.showToast(msg: "logOut User");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
  }

//user view code//

  Future<void> fetchUserData(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("user");
    try {
      final dataSnapshot = await ref.get();
      if (dataSnapshot.exists) {
        final dataMap = Map<String, dynamic>.from(dataSnapshot.value as Map);
        final List<UserModel> tempList = dataMap.entries.map((e) {
          return UserModel.fromJson(Map<String, dynamic>.from(e.value));
        }).toList();
        _userData = tempList;
        notifyListeners();
      } else {
        _userData = [];
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _userData = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    if (currentUser != null) {
      print("No user is LoggedIn");
      return;
    }
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref("user/$currentUser");
      final datasnapShot = await databaseReference.get();
      if (datasnapShot.exists) {
        _currentUser = UserModel.fromJson(
            Map<String, dynamic>.from(datasnapShot.value as Map));
        notifyListeners();
      } else {
        print("No data found");
      }
    } catch (ex) {
      print("Error $ex");
    }
  }

}
