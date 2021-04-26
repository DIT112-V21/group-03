import 'package:flutter/material.dart';



class CustomPage extends StatefulWidget {
  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Custom'),
        backgroundColor:Colors.green.shade400,
      ),
      body: Center(
        child: Text('Soon Custom'),
      ),
    );
  }
}
