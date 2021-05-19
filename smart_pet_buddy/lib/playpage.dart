import 'package:flutter/material.dart';
import 'constants.dart';
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
        backgroundColor: strongPrimary,
          title: Text(''),
        //   actions: [
        //   IconButton(
        //       onPressed: () => Navigator.push( context, MaterialPageRoute(builder: (context) => RaceMode()
        //       )
        //       ),
        //       icon: Icon(Icons.speed),
        //   )
        // ],
     ),
      body:Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/homepage.jpg'),
              fit: BoxFit.cover,
            )
        ),
        child: Controlpanel(),
      )

    );
  }
}
