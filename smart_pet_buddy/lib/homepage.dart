import 'package:flutter/material.dart';

import 'controlpanel.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor:Colors.green.shade400,
      ),
      body: Controlpanel(),
    );
  }
}
