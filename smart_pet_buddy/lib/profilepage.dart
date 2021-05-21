import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/edit_profile.dart';
import 'package:wiredash/wiredash.dart';
import 'appbar_widget.dart';
import 'package:smart_pet_buddy/settingspage.dart';



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
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.only(left: 40, top: 30, right: 15),
            child: Text(
              'Hello!',
              style: TextStyle(color: Colors.grey[700],
                fontSize: 35,
                fontWeight: FontWeight.bold,),

            ),
          ),
          const SizedBox(height: 24),
          ProfileMenu(text: "My Account",
            press: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditProfilePage(widget.app)));
            },
          ),
          ProfileMenu(text: "Settings",
            press: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsPage(widget.app)));

            },
          ),
          ProfileMenu(text: "FAQ & Feedback",
            press: () {
              Wiredash.of(context).show();
            },
          ),
          ProfileMenu(text: "More",
            press: () {

            },
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical:10),
      child: TextButton(
        style: TextButton.styleFrom( padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Color(0xFFF5F6F9)),
        onPressed: press,
        child: Row(
          children: [
            SizedBox(width: 20),
            Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyText1,
            ),
            ),
            Icon(Icons.arrow_forward_ios)


          ],
        ),

      ),
    );
  }
}
