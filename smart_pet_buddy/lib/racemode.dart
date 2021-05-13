import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sensors/sensors.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';

class RaceMode extends StatefulWidget {

  @override
  _RaceModeState createState() => _RaceModeState();
}

class _RaceModeState extends State<RaceMode> {


  /*
  Title: Flutter Sensors Plugin – Accelerometer and Gyroscope sensor library
  Author: Rajat Palankar
  Date: February 17, 2020
  Availabilty: https://protocoderspoint.com/flutter-sensors-plugin-accelerometer-and-gyroscope-sensors-library/
  Modified to suit our needs
  */

  MqttServerClient client = SpbMqttClient.client;
  double x, y, z;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent  event) {
      setState(() {
        x = event.x;  //current speed(used for throttle)
        y = event.y;  //current angle(used for steer)
        z = event.z; //don't think we need this one, not sure what to use it for
      });

      if(x<5 && x > -5){
        x *= 20;
        _throttle(x.toStringAsFixed(0));
      }

      if(y<5 && y > -5){
        y *= 20;
        _steer(y.toStringAsFixed(0));
      }
    });
  }

  void _throttle(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage('/smartcar/group3/control/throttle',
        MqttQos.atLeastOnce, builder.payload);
  }

  void _steer(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage('/smartcar/group3/control/steering',
        MqttQos.atLeastOnce, builder.payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Race Mode"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "An Example How on Flutter Sensor library is used",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                ),
              ),
              Table(
                border: TableBorder.all(
                    width: 2.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "X Asis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(x.toStringAsFixed(0), //trim the asis value to 0 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Y Asis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(y.toStringAsFixed(0),  //trim the asis value to 0 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Z Asis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(z.toStringAsFixed(0),   //trim the asis value to 0 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
