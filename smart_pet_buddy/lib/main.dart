// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

//import 'package:firebase_auth/firebase_auth.dart';
// Only needed if you configure the Auth Emulator below
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/register_page.dart';
import 'package:smart_pet_buddy/signin_page.dart';
import 'package:wiredash/wiredash.dart';

//import 'package:flutter_signin_button/button_builder.dart';
import './register_page.dart';
import './signin_page.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');

  runApp(MyApp(app));
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  final FirebaseApp app;

  MyApp(this.app);

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      navigatorKey: navigatorKey,
      projectId: 'smartpetbuddy-0cqv52o',
      secret: 'gw1n6lba8xkdisjk92zlkat9luge7ju8dqt95hbaaxv1xj2s',
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: SmartPetBuddy(app),
      ),
    );
  }
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
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/landing_logo.png"),
                  fit: BoxFit.cover,
                )),
              ),
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
                              builder: (context) => SignInPage(app)));
                    },
                    color: midShade,
                    // defining the shape
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: textColor),
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
                  // creating the sign-up button
                  SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage(app)));
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
