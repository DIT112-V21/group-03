import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';
import 'flutter_mqtt_client.dart';
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
          title: Text('Home'),
          backgroundColor: Colors.green.shade400,
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
                  await _signOut();

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
        body: Column(
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
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'To start please connect to the car :)',
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
                child: SpbMqttClient.isConnected
                    ? TextButton(
                        child: Text('Disconnect',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () => {
                          () {
                            client.disconnect();
                            setState(() {});
                          }
                        },
                      )
                    : TextButton(
                        child: Text('Connect',
                            style: TextStyle(color: Colors.green)),
                        onPressed: () => {
                          connect().then((value) {
                            client = value;
                            SpbMqttClient.client = client;
                            setState(() {});
                          })
                        },
                      )),
          ],
        ));
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AuthTypeSelector(widget.app)));
  }
}
