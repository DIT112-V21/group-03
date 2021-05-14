import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/custompage.dart';
import 'package:smart_pet_buddy/homepage.dart';
import 'package:smart_pet_buddy/playpage.dart';
import 'package:smart_pet_buddy/profilepage.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class ConvexBottomBar extends StatefulWidget {
  final FirebaseApp app;

  ConvexBottomBar(this.app);

  @override
  _ConvexBottomBarState createState() => _ConvexBottomBarState();
}

class _ConvexBottomBarState extends State<ConvexBottomBar> {
  int _currentIndex = 0;
  MqttServerClient client;

  List<Widget> tabs = <Widget>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //connect().then((value) {
    //client = value;
    //});
    tabs = [HomePage(), PlayPage(), CustomPage(), ProfilePage(widget.app)];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Bar'),
      // ),
      body: tabs[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.green,
          items: [
            TabItem(icon: Icons.home_outlined, title: 'Home'),
            TabItem(icon: Icons.directions_car_outlined, title: 'Play'),
            TabItem(icon: Icons.play_circle_outline, title: 'Custom'),
            TabItem(icon: Icons.account_circle_outlined, title: 'Profile'),
          ],
          initialActiveIndex: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}

