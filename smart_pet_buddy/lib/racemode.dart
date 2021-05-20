import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sensors/sensors.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';

class RaceMode extends StatefulWidget {
  @override
  _RaceModeState createState() => _RaceModeState();
}

class _RaceModeState extends State<RaceMode> {
  MqttServerClient client = SpbMqttClient.client;
  double x, y, z;
  int speed = 0;
  int currentSpeed;
  int maxGear = 5;
  int minGear = -5;
  final snackBar = SnackBar(content: Text('Car is not connected! Go to Homepage'));


  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        print('X: $x'); //current speed(used for throttle)
        y = event.y;
        print('Y: $y'); //current angle(used for steer)
        z = event.z;
        print(
            'Z: $z'); //don't think we need this one, not sure what to use it for
      });

      //maybe remove this part and instead do a button, also too sensitive
      // if(x<5 && x > -5){
      //   x *= 20;
      //   _throttle(x.toStringAsFixed(0));
      // }

      //This part controls the steering
      if (y < 5 && y > -5) {
        y *= 20;
        _steer(y.toStringAsFixed(0));
      }
    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _forward() {
    if (speed <= maxGear) {
      setState(() {
        speed++;
      });
    }

    currentSpeed = speed * 20;
    _throttle('$currentSpeed');
  }

  void _reverse() {
    if (speed >= minGear) {
      setState(() {
        speed--;
      });
    }

    currentSpeed = speed * 20;
    _throttle('$currentSpeed');
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

  void _initRaceModeStatus(){

    if(client != null && client.connectionStatus.state == MqttConnectionState.connected){
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _initRaceModeStatus();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Race Mode"),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: TextButton(
                child: Text('Try the normal mode!'),
                onPressed: () => Navigator.pop(context)),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Text(
                  "Tilt your phone to steer and use the button to increase/decrease the speed",
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: _forward, child: Text('Gas')),
                  TextButton(onPressed: _reverse, child: Text('Break')),
                ],
              ),
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.all(10.0),
      //         child: Text(
      //           "Tilt your phone to steer and use the button to increase/decrease the speed",
      //           style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
      //         ),
      //       ),
      //

      //     ],
      //   ),
      // ));
    );
  }
}