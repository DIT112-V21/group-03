import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';
import 'constants.dart';
import 'flutterMqttClient.dart';
import 'main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).buttonColor)),
              onPressed: () async {
                final User user = _auth.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                await signOut();

                final String uid = user.uid;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$uid has successfully signed out.'),
                ));
              },
              child: const Text('Sign out'),
            );
          })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/homepage.jpg'),
          fit: BoxFit.cover,
        )),
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
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'To start playing please connect to the car :)',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                child: SpbMqttClient.isConnected
                    ? ElevatedButton(
                        onPressed: () => {client.disconnect(), setState(() {})},
                        child: Icon(
                          Icons.stop,
                          color: Colors.white,
                          size: 60.0,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 50),
                          shape: CircleBorder(),
                          primary: Colors.red.shade700,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () => {
                          connect().then((value) {
                            if (SpbMqttClient.isConnected) {
                              client = value;
                              SpbMqttClient.client = client;
                              setState(() {});
                            } else {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Error'),
                                        content: Text(
                                            SpbMqttClient.mqttError.toString()),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ));
                            }
                          })
                        },
                        child: Icon(
                          Icons.online_prediction_outlined,
                          color: Colors.white,
                          size: 60.0,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 50),
                            shape: CircleBorder(),
                            primary: Colors.green.shade700),
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

  Future<void> signOut() async {
    await _auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SmartPetBuddy(widget.app)));
  }
}
