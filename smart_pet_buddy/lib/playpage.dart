import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'controlpanel.dart';

class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

@override
void initState() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // imageValueNotifier.value = SpbMqttClient.image;
}

@override
void dispose() {;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: strongPrimary,
          actions: [
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Help'),
                  content: const Text(
                      'Make sure you have connect to the car. (You can do so on the homepage!) '
                          'Control the car by pressing the arrow buttons. There are five different gears that you can use. '
                          'To control the speed press the + or - at the buttom of the page '),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/homepage.jpg'),
            fit: BoxFit.cover,
          )),
          child: Controlpanel(),
        ));
  }
}
