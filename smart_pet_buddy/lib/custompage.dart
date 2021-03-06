import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/movementInfo.dart';
import 'package:smart_pet_buddy/movementWidget.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'constants.dart';

class CustomPage extends StatefulWidget {
  CustomPage({Key key}) : super(key: key);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  String commandRunning = "";
  MqttServerClient client = SpbMqttClient.client;
  static String imageUrlBee =
      'https://images.unsplash.com/photo-1560114928-40f1f1eb26a0?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80';
  static String imageUrlCircle =
      'https://images.unsplash.com/photo-1494256997604-768d1f608cac?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2001&q=80';
  static String imageUrlZigzag =
      'https://images.unsplash.com/photo-1562119464-eaa5ff353ead?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1189&q=80';
  static String imageUrlBackForth =
      'https://images.unsplash.com/photo-1529257414772-1960b7bea4eb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&dl=james-sutton-dQ5G0h7sLno-unsplash.jpg';

  static MovementInfo beeDance =
      MovementInfo('BeeDance', imageUrlBee, 'beeDance');
  static MovementInfo circle = MovementInfo('Circle', imageUrlCircle, 'circle');
  static MovementInfo zigzag = MovementInfo('Zigzag', imageUrlZigzag, 'zigzag');
  static MovementInfo backForth =
      MovementInfo('BackForth', imageUrlBackForth, 'forthBack');
  List<MovementInfo> movementList = <MovementInfo>[
    beeDance,
    circle,
    zigzag,
    backForth
  ];
  final snackBar =
      SnackBar(content: Text('Car is not connected! Go to Homepage'));

  @override
  void initState() {
    super.initState();
  }

  void _command(String command) {
    final builder = MqttClientPayloadBuilder();
    if (commandRunning != "") {
      setState(() {
        commandRunning = "";
      });
      builder.addString('stop');
      client?.publishMessage('/smartcar/group3/control/automove',
          MqttQos.atLeastOnce, builder.payload);
    } else {
      setState(() {
        commandRunning = command;
      });
      builder.addString(command);
      client?.publishMessage('/smartcar/group3/control/automove',
          MqttQos.atLeastOnce, builder.payload);
    }
  }

  void _initCommandStatusListener() {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
      client?.subscribe(
          "/smartcar/group3/control/automove/complete", MqttQos.atLeastOnce);
      client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        // only care about the first message
        if (c[0].topic == "/smartcar/group3/control/automove/complete") {
          setState(() {
            // reset commandRunning when auto car movement is complete
            commandRunning = "";
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCommandStatusListener();
    });
    return Scaffold(
        backgroundColor: lightShade,
        appBar: AppBar(
          title: Text(''),
          backgroundColor: strongPrimary,
        ),
        body: Container(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            itemCount: movementList.length,
            itemBuilder: (BuildContext context, int index) {
              return MovementWidget(movementList[index], commandRunning,
                  () => {_command(movementList[index].command)});
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ));
  }
}
