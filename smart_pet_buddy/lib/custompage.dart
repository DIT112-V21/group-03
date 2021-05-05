import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/movementInfo.dart';
import 'package:smart_pet_buddy/movementWidget.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class CustomPage extends StatefulWidget {
  CustomPage({Key key}) : super(key: key);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  bool commandRunning = false;
  MqttServerClient client = SpbMqttClient.client;
  static String imageUrlBee =
      'https://images.unsplash.com/photo-1560114928-40f1f1eb26a0?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80';
  static String imageUrlCircle =
      'https://images.unsplash.com/photo-1494256997604-768d1f608cac?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2001&q=80';
  static String imageUrlZigzag =
      'https://images.unsplash.com/photo-1562119464-eaa5ff353ead?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1189&q=80';
  static MovementInfo beeDance =
      MovementInfo('BeeDance', imageUrlBee, 'beeDance');
  static MovementInfo stop = MovementInfo('Stop', imageUrlBee, 'stop');
  static MovementInfo circle = MovementInfo('Circle', imageUrlCircle, 'circle');
  static MovementInfo zigzag = MovementInfo('Zigzag', imageUrlZigzag, 'zigzag');
  List<MovementInfo> movementList = <MovementInfo>[beeDance, circle, zigzag, stop];

  @override
  void initState() {
    super.initState();
  }

  void _command(String command) {
    final builder = MqttClientPayloadBuilder();
    setState(() {
      commandRunning = true;
    });
    builder.addString(command);
    client?.publishMessage('/smartcar/group3/control/automove',
        MqttQos.atLeastOnce, builder.payload);
  }

  void _initCommandStatusListener() {
    client?.subscribe("/smartcar/group3/control/automove/complete", MqttQos.atLeastOnce);
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      if(c[0].topic == "/smartcar/group3/control/automove/complete") {
        setState(() {
          commandRunning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _initCommandStatusListener();
    return Scaffold(
        appBar: AppBar(
          title: Text('Custom'),
          backgroundColor: Colors.green.shade400,
        ),
        body: Container(
          //child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            itemCount: movementList.length,
            itemBuilder: (BuildContext context, int index) {
              return MovementWidget(
                  movementList[index],
                  commandRunning,
                  () => {
                    _command(movementList[index].command)
                  }
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),


          ),
        ));
  }
}