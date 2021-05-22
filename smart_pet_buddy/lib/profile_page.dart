import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/edit_profile.dart';
import 'package:wiredash/wiredash.dart';
import 'package:smart_pet_buddy/settingspage.dart';
import 'constants.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseApp app;

  ProfilePage(this.app);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: strongPrimary,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app_outlined),
              padding: EdgeInsets.all(10),
              iconSize: 40,
              color: lightShade,
              onPressed: () => exit(0))
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 25),
          Container(
            padding: EdgeInsets.only(left: 40, top: 30, right: 15),
            child: Text(
              'Hello, Smart Pet Owner!',
              style: TextStyle(
                color: textColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nexa Rust',
              ),
            ),
          ),
          SizedBox(height: 30,),
          ProfileMenu(
            text: "Edit profile",
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EditProfilePage(widget.app)));
            }
          ),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Settings",
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SettingsPage(widget.app)));
            },
          ),
          SizedBox(height:20),
          ProfileMenu(
            text: "FAQ & Feedback",
            press: () {
              Wiredash.of(context).show();
            },
          ),
          // ProfileMenu(
          //   text: "More",
          //   press: () {},
          // ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: lightShade),
        onPressed: press,
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: strongPrimary, fontWeight: FontWeight.bold, fontSize: 18,
                fontFamily: 'Nexa Rust'),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: strongPrimary,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}
