// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

//import 'package:firebase_auth/firebase_auth.dart'; // Only needed if you configure the Auth Emulator below
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/register_page.dart';
import 'package:smart_pet_buddy/signin_page.dart';

//import 'package:flutter_signin_button/button_builder.dart';
import './register_page.dart';
import './signin_page.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SmartPetBuddy(app),
  ));
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class SmartPetBuddy extends StatelessWidget {
  final FirebaseApp app;

  SmartPetBuddy(this.app);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPrimary,
      // decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage('assets/images/homepage.jpg'),
      //       fit: BoxFit.cover,
      //     )
      // ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  // Text(
                  //   "SMART PET BUDDY",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontFamily: 'Lato',
                  //     fontWeight: FontWeight.w800,
                  //     fontSize: 30,
                  //   ),
                  // ),

                  // Text(
                  //   "We Love Your Pet",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //   ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  // image: NetworkImage(
                  //  'https://media1.tenor.com/images/fad0fe04b7ca06b8924bda17af7cf571/tenor.gif')
                  image: AssetImage("assets/images/smart-pet-buddy.png"),
                  fit: BoxFit.cover,
                )),
              ),
              // SizedBox(
              //   width: 300.0,
              //   child: AnimatedTextKit(
              //     animatedTexts: [
              //       ColorizeAnimatedText(
              //         'We Love Your Pet',
              //         textStyle: colorizeTextStyle,
              //         colors: colorizeColors,
              //       ),
              //     ],
              //     isRepeatingAnimation: true,
              //     onTap: () {
              //       print("Tap Event");
              //     },
              //   ),
              // ),
              Column(
                children: <Widget>[
                  // the login button
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPageNew(app)));
                    },
                    color: lightShade,
                    // defining the shape
                    shape: RoundedRectangleBorder(
                        side: BorderSide( color: textColor),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          fontFamily: 'Nexa Rust'),
                    ),
                  ),
                  // creating the signup button
                  SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPageNew(app)));
                    },
                    color: strongPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          fontFamily: 'Nexa Rust'),
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
}
