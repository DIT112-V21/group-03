import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_pet_buddy/movementInfo.dart';
import 'package:smart_pet_buddy/movementWidget.dart';
import 'controlpanel.dart';
import 'flutter_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';



class CustomPage extends StatefulWidget {
  CustomPage({Key key}) : super(key: key);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  MqttServerClient client = Controlpanel.client;
  static String imageUrl = 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&dl=alexander-london-mJaD10XeD7w-unsplash.jpg';
  static MovementInfo beeDance = MovementInfo('beeDance', imageUrl, 'beeDance');
  static MovementInfo circle = MovementInfo('circle', imageUrl, 'circle');
  static MovementInfo zigzag = MovementInfo('zigzag', imageUrl, 'zigzag');
  List <MovementInfo> movementList = <MovementInfo> [beeDance, circle, zigzag];

  void _command(String command) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(command);
    client?.publishMessage('/smartcar/group3/control/automove',
        MqttQos.atLeastOnce, builder.payload);
  }

 /* void _beeDance() {
    final builder = MqttClientPayloadBuilder();
    builder.addString("beeDance");
    client?.publishMessage('/smartcar/group3/control/automove',
        MqttQos.atLeastOnce, builder.payload);
  }

  void _zigzag() {
    final builder = MqttClientPayloadBuilder();
    builder.addString("snake");
    client?.publishMessage('/smartcar/group3/control/automove',
        MqttQos.atLeastOnce, builder.payload);
  }

  void _circle() {
    final builder = MqttClientPayloadBuilder();
    builder.addString("circle");
    client?.publishMessage('/smartcar/group3/control/automove',
        MqttQos.atLeastOnce, builder.payload);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Custom'),
          backgroundColor: Colors.green.shade400,
        ),
        body: Container(
          //child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          child:
            ListView.separated(
              itemCount: movementList.length ,  itemBuilder: (BuildContext context, int index) {
              return MovementWidget(movementList[index], () => {_command(movementList[index].command)});
            },
              separatorBuilder: (BuildContext context, int index) => const Divider(),





              //mainAxisAlignment: MainAxisAlignment.center,
             // children: [
             /*   Container(*/
             /*       child: TextButton(*/
             /*         child: Text('Connect'),*/
             /*         onPressed: () =>*/
             /*         {*/
             /*           connect().then((value) {*/
             /*             client = value;*/
             /*           })*/
             /*         },*/
             /*       )),*/
             /*   Container(*/
             /*     decoration: BoxDecoration(*/
             /*       color: Colors.green,*/
             /*       image: DecorationImage(*/
             /*         image: NetworkImage('https://images.unsplash.com/photo-1495360010541-f48722b34f7d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&dl=alexander-london-mJaD10XeD7w-unsplash.jpg'),*/
             /*         fit: BoxFit.cover,*/
             /*         ),*/
             /*           border: Border.all(*/
             /*             color: Colors.black12,*/
             /*             width: 8,*/
             /*         ),*/
             /*       borderRadius: BorderRadius.circular(12),*/
             /*     ),*/
             /*       child: TextButton(*/
             /*         child: Text('BeeDance'),*/
             /*         onPressed: _beeDance,*/
             /*       )),*/
             /*   Container(*/
             /*       child: TextButton(*/
             /*         child: Text('Circle'),*/
             /*         onPressed: _circle,*/
             /*       )),*/
             /*   Container(*/
             /*       child: TextButton(*/
             /*         child: Text('Zigzag'),*/
             /*         onPressed: _zigzag,*/
                   // )),
              //],
            ),
          //]
          //),
        )
    );
  }
}