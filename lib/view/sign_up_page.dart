import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controller/user_view_model.dart';
import 'LoginPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var provider = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            alignment: Alignment.topLeft,
          ),
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: takeImage,
                      child: CircleAvatar(
                        maxRadius: 60,
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        backgroundImage:
                            imageFile != null ? FileImage(imageFile!) : null,
                        child: imageFile == null
                            ? const Icon(Icons.camera_alt_outlined)
                            : null,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: provider.nameController,
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: provider.emailController,
                      decoration: InputDecoration(
                        hintText: " Enter Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: provider.passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              signUpAndUploadImage(provider);
                            },
                            child: const Text("Sign Up"),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text("Already have an account"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 10, top: 80),
                child: Text("Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takeImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        imageFile = File(img.path);
      });
    }
  }

  Future<void> uploadImage(String uId) async {
    if (imageFile == null) return;

    try {
      Reference storeImage =
          FirebaseStorage.instance.ref().child('profile_Pic/$uId.jpg');
      await storeImage.putFile(imageFile!); // Wait for the upload to complete
      String imageUrl =
          await storeImage.getDownloadURL(); // Get the download URL

      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child("user/$uId");
      await databaseRef.update({"profilePicture": imageUrl});
    } catch (ex) {
      print("Error uploading image: $ex");
    }
  }

  Future<void> signUpAndUploadImage(UserViewModel provider) async {
    try {
      await provider.userSignUp(context);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await uploadImage(user.uid);
      }
    } catch (ex) {
      print("Error during sign up: $ex");
    }
  }
}
