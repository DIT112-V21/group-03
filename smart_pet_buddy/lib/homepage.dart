import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';
import 'constants.dart';
import 'flutter_mqtt_client.dart';

//ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final FirebaseApp app;

  HomePage({Key key, this.app}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MqttServerClient client = SpbMqttClient.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: strongPrimary,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/homepage.jpg'),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 40,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'To start playing please connect to the car :)',style: TextStyle(
                      fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                child: SpbMqttClient.isConnected
                    ? ElevatedButton(
                  onPressed: () => {
                      client.disconnect(),
                      setState(() {})
                  },
                  child: Icon(
                    Icons.stop,
                    color: Colors.white,
                    size: 60.0,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                      shape: CircleBorder(), primary: Colors.red.shade700, ),
                  )
                    : ElevatedButton(
                  onPressed: () => {
                    connect().then((value) {
                      client = value;
                      SpbMqttClient.client = client;
                      setState(() {});
                    })
                  },
                  child: Icon(
                    Icons.online_prediction_outlined,
                    color: Colors.white,
                    size: 60.0,
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                      shape: CircleBorder(), primary: Colors.green.shade700),

                )),
            // Flexible(
            //     child: SpbMqttClient.isConnected
            //         ? TextButton(
            //             child: Text('Disconnect'),
            //             style: TextButton.styleFrom(
            //               primary: Colors.red,
            //               side: BorderSide(color: Colors.red)
            //             ),
            //             onPressed: () => {
            //               () {
            //                 client.disconnect();
            //                 setState(() {});
            //               }
            //             },
            //           )
            //         : TextButton(
            //             child: Text('Connect'),
            //             style: TextButton.styleFrom(
            //               primary: Colors.white,
            //               backgroundColor: Colors.green,
            //             ),
            //             onPressed: () => {
            //               connect().then((value) {
            //                 client = value;
            //                 SpbMqttClient.client = client;
            //                 setState(() {});
            //               })
            //             },
            //           )),
          ],
        ),
        ),
    );
  }

}
