import 'package:flutter/material.dart';





class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Profile'),
        backgroundColor:Colors.green.shade400,
      ),
      body: Center(
        child: Text('Soon Profile'),
      ),
    );
  }
}
