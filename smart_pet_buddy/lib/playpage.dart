import 'package:flutter/material.dart';

import 'controlpanel.dart';



class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Play'),
        backgroundColor:Colors.green.shade400,
      ),
      body: Center(
        child: Text('Soon Play'),
      ),
    );
  }
}
