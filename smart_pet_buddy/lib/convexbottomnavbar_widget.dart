import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/constants.dart';
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
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
            backgroundColor: midPrimary,
            activeColor: lightShade,
            height: 50,
            top: -30,
            curveSize: 100,
            items: [
              TabItem(icon: Icons.home_outlined, title: 'Home'),
              TabItem(icon: Icons.control_camera_outlined, title: 'Play'),
              TabItem(icon: Icons.pest_control_rodent_outlined, title: 'Auto'),
              TabItem(icon: Icons.account_circle_outlined, title: 'Profile'),
            ],
            //style: TabStyle.fixed,
            initialActiveIndex: 0,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            }),
      )
    );
  }
}


class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 30;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 20, color: color);
  }
}
