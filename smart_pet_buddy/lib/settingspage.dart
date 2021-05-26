import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_pet_buddy/constants.dart';
import 'package:smart_pet_buddy/dialogs.dart';
import 'package:smart_pet_buddy/playReminders.dart';
import 'package:smart_pet_buddy/privacyPage.dart';


import 'constants.dart';

class SettingsPage extends StatefulWidget {
  final FirebaseApp app;

  SettingsPage(this.app);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCD5),
      appBar: AppBar(
          backgroundColor: strongPrimary,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_outlined,
              color: lightShade,
            size: 40,),

          )
      ),
      body: Container(
        padding: EdgeInsets.only(left:16, top:25, right: 16),
        child: ListView(
          children: [
            Text("Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(Icons.person_outlined, color: midPrimary,),
                SizedBox(width: 8,),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 20,
            ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    TextButton(
    child: Text("Reminders"),
    style: TextButton.styleFrom(
    primary: Colors.grey[600],
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),

    onPressed: () async {  Navigator.of(context).push(MaterialPageRoute(builder: (_) => RemindersPage(widget.app)));

    },
    ),
    Icon(
    Icons.arrow_forward_ios,
    color: Colors.grey
    ),
    ]
    ),
    SizedBox(
    height: 10,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:[
    TextButton(
    child: Text("Language"),
    style: TextButton.styleFrom(
    primary: Colors.grey[600],
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),

    onPressed: () async {
    await Dialogs.yesAbortDialog(context, " Select language", "Body");
    },
    ),


    Icon(
    Icons.arrow_forward_ios,
    color: Colors.grey
    ),
    ],
    ),

    SizedBox(
    height: 10,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    TextButton(
    child: Text("Privacy & security",
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.grey[600])
    ),
      onPressed: () async {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrivacyPage(widget.app)));

      },
    ),


      Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey
      ),
    ],
    ),

            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(Icons.volume_up_outlined, color: Color(0xFF62A8AC)),
                SizedBox(width: 8,),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Connect bluetooth collar",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                        value: true,
                        onChanged: (bool value) {}
                    ))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Account activity ", style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600], ),
                ),
                Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                        value: true,
                        onChanged: (bool value) {}
                    ))
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("© Smart Pet Buddy | version 1.0", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey[400], ),
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }
}