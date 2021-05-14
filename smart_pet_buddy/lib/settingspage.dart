import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(FirebaseApp app);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green.shade400,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,
              color: Colors.white,),
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
                Icon(Icons.person_outlined, color: Colors.green,),
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
                  Text("Content settings", style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600], ),
                  ),
                  Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey
                  ),
                ]
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Language",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey
                  ),
                ]
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Privacy & security",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey
                  ),
                ]
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Feedback",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey
                  ),
                ]
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(Icons.volume_up_outlined, color: Colors.green,),
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
