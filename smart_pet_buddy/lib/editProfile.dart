import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_pet_buddy/passwordInput.dart';
import 'constants.dart';

class EditProfilePage extends StatefulWidget {
  final FirebaseApp app;

  EditProfilePage(this.app);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = FirebaseAuth.instance.currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String userLocation = '';

  @override
  Widget build(BuildContext context) {
    nameController.text = user.displayName;
    emailController.text = user.email;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) => locationController.text = value.data()['location']);

    return Scaffold(
      backgroundColor: lightShade,
      appBar: AppBar(
        backgroundColor: strongPrimary,
        elevation: 1,
        leading: IconButton(
          padding: EdgeInsets.all(10),
          icon: Icon(
            Icons.arrow_back_outlined,
            size: 40,
            color: lightShade,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nexa Rust',
                    color: textColor),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 6,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: user.photoURL != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    user.photoURL,
                                  ))
                              : null,
                        )),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            PickedFile image = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            print(image.toString());
                            TaskSnapshot snapshot = await FirebaseStorage
                                .instance
                                .ref()
                                .child('user_image/${user.uid}')
                                .putFile(File(image.path));
                            String url = await snapshot.ref.getDownloadURL();

                            user
                                .updateProfile(photoURL: url)
                                .whenComplete(() async {
                              print('Successful photo change');
                              user = FirebaseAuth.instance.currentUser;
                              setState(() {});
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: strongPrimary,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField(
                "Full Name",
                "",
                nameController,
              ),
              buildTextField("E-mail", "", emailController),
              PasswordInput(
                labelText: "Password",
                placeholder: "********",
                textController: passwordController,
              ),
              buildTextField("Location", "", locationController),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: strongShade,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: textColor)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (user.displayName != nameController.text) {
                        await user
                            .updateProfile(displayName: nameController.text)
                            .whenComplete(() => print('success name change'));
                      }
                      if (user.email != emailController.text) {
                        await user
                            .updateEmail(emailController.text)
                            .whenComplete(() => print('success email change'));
                      }
                      if (passwordController.text.length >= 8) {
                        await user
                            .updatePassword(passwordController.text)
                            .whenComplete(() => print('success pass change'));
                      }
                      if (userLocation != locationController.text) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .set({'location': locationController.text});
                        print('success location change');
                      }

                      user = FirebaseAuth.instance.currentUser;
                    },
                    style: ElevatedButton.styleFrom(
                      primary: strongPrimary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Nexa Rust',
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: midShade),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  buildTextField(String label, String placeholder,
      TextEditingController textEditingController) {
    return Padding(
      padding: EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nexa Rust',
              color: midPrimary,
            )),
      ),
    );
  }
}
