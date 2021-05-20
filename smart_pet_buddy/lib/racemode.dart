import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sensors/sensors.dart';
import 'package:smart_pet_buddy/constants.dart';
import 'package:smart_pet_buddy/raceMode_dialog.dart';
import 'package:smart_pet_buddy/spbMqttClient.dart';

class RaceMode extends StatefulWidget {
  @override
  _RaceModeState createState() => _RaceModeState();
}

class _RaceModeState extends State<RaceMode> {
  MqttServerClient client = SpbMqttClient.client;
  double x, y, z;
  int speed = 0;
  int currentSpeed = 0;
  int maxGear = 5;
  int minGear = -5;
  final snackBar =
      SnackBar(content: Text('Car is not connected! Go to Homepage'));

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted)
        setState(() {
          x = event.x;
          print('X: $x'); //current speed(used for throttle)
          y = event.y;
          print('Y: $y'); //current angle(used for steer)
          z = event.z;
          print(
              'Z: $z'); //don't think we need this one, not sure what to use it for
        });

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
    if (speed < maxGear) {
      if (mounted)
        setState(() {
          speed++;
        });
    }

    currentSpeed = speed * 20;
    _throttle('$currentSpeed');
  }

  void _reverse() {
    if (speed > minGear) {
      if (mounted)
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

  void _initRaceModeStatus() {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
    } else {
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
        backgroundColor: strongPrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => RaceModeDialog()
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: TextButton(
                    child: Text(
                      'Try the normal mode!',
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(padding: EdgeInsets.all(30))),
              ),
              //IconButton(icon: Icon(Icons.help), onPressed: null, color: Colors.red,)
            ],
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _forward,
                    child: Text('GAS'),
                    style: ElevatedButton.styleFrom(
                      primary: strongShade,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _reverse,
                    child: Text('BREAK'),
                    style: ElevatedButton.styleFrom(
                      primary: strongShade,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(
                        text: 'Speed: ',
                        style: TextStyle(color: textColor),
                        children: <TextSpan>[
                      TextSpan(
                          text: '$speed ',
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold)),
                      TextSpan(text: '    '),
                      TextSpan(
                          text: 'Angle: ', style: TextStyle(color: textColor)),
                      TextSpan(
                          text: y.toStringAsFixed(0),
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold)),
                    ])),
              ],
            ),
          )
        ],
      ),
    );
  }
}
