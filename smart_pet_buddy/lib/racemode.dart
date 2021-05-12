import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RaceMode extends StatefulWidget {
  @override
  _RaceModeState createState() => _RaceModeState();
}

class _RaceModeState extends State<RaceMode> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Play'),
        backgroundColor:Colors.green.shade400,
      ),
      body: Center(
        child: Text('Under construction'),
      )

    );
  }
}
