import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';
import 'constants.dart';
import 'flutterMqttClient.dart';

//ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final FirebaseApp app;

  HomePage({Key key, this.app}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MqttServerClient client = SpbMqttClient.client;
  TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

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
                    : Container(
                        child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text("Mqtt Broker address:"),
                            TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  hintText: SpbMqttClient.address),
                              validator: (String value) {
                                if (value.isNotEmpty) {
                                  bool ipValid = RegExp(
                                          r'^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$')
                                      .hasMatch(value);
                                  bool urlValid = RegExp(
                                          r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?')
                                      .hasMatch(value);
                                  return urlValid && ipValid
                                      ? null
                                      : "Invalid url";
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  SpbMqttClient.address =
                                      _controller.text.isEmpty
                                          ? '127.0.0.1'
                                          : _controller.text;
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
                                                content: Text(SpbMqttClient
                                                    .mqttError
                                                    .toString()),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ));
                                    }
                                  });
                                }
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
                            )
                          ],
                        ),
                      ))),
          ],
        ),
      ),
    );
  }
}
