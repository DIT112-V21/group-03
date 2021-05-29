import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_pet_buddy/controlpageDialog.dart';
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
void dispose() {
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
                  builder: (BuildContext context) => ControlpageDialog()),
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
