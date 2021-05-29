import 'package:bitmap/bitmap.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_pet_buddy/constants.dart';

//import 'flutter_mqtt_client.dart';
import 'package:smart_pet_buddy/racemode.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math';
import 'package:smart_pet_buddy/spbMqttClient.dart';

class Controlpanel extends StatefulWidget {
  Controlpanel({
    Key key,
  }) : super(key: key);
  @override
  ControlpanelState createState() => ControlpanelState();
}

class ControlpanelState extends State<Controlpanel> {
  MqttServerClient client = SpbMqttClient.client;

  int _counter = 0;
  int currentSpeed = 0;
  int reverseSpeed = -30;
  bool isForward = false;
  bool isReversed = false;
  bool isLeft = false;
  bool isRight = false;
  String steerNeutral = '0';
  String steerLeft = '-75';
  String steerRight = '75';
  String throttleNeutral = '0';
  int multiplier = 20;
  int maxGear = 5;
  final snackBar =
      SnackBar(content: Text('Car is not connected! Go to Homepage'));

  void _backward() {
    setState(() {
      isForward = false;
      isLeft = false;
      isRight = false;
      isReversed = !isReversed;
    });
    if (isReversed) {
      _throttle('$reverseSpeed');
      _steer(steerNeutral);
    } else {
      _throttle(throttleNeutral);
    }
  }

  void _forward() {
    setState(() {
      isForward = !isForward;
      isLeft = false;
      isRight = false;
      isReversed = false;
    });
    if (isForward) {
      _throttle('$currentSpeed');
      _steer(steerNeutral);
    } else {
      _throttle(throttleNeutral);
    }
  }

  void _left() {
    setState(() {
      isLeft = true;
      isRight = false;
    });

    _steer(steerLeft);
    if (isForward) {
      _throttle('$currentSpeed');
    }
    if (isReversed) {
      _throttle('$reverseSpeed');
    }
  }

  void _cancelLeft() {
    setState(() {
      isLeft = false;
    });

    _steer(steerNeutral);
    if (isForward) {
      _throttle('$currentSpeed');
    }
    if (isReversed) {
      _throttle('$reverseSpeed');
    }
  }

  void _right() {
    setState(() {
      isRight = true;
      isLeft = false;
    });

    _steer(steerRight);
    if (isForward) {
      _throttle('$currentSpeed');
    }
    if (isReversed) {
      _throttle('$reverseSpeed');
    }
  }

  void _cancelRight() {
    setState(() {
      isRight = false;
    });
    _steer(steerNeutral);
    if (isForward) {
      _throttle('$currentSpeed');
    }
    if (isReversed) {
      _throttle('$reverseSpeed');
    }
  }

  void _addSpeed() {
    setState(() {
      if (_counter < maxGear) _counter++;
    });
    currentSpeed = _counter * multiplier;
    if (isForward || isLeft || isRight) {
      _throttle('$currentSpeed');
    }
  }

  void _reduceSpeed() {
    setState(() {
      if (_counter > 0) _counter--;
      if (_counter == 0) {
        isForward = false;
        isRight = false;
        isLeft = false;
        _throttle(throttleNeutral);
      }
    });
    currentSpeed = _counter * multiplier;
    if (isForward || isLeft || isRight) {
      _throttle('$currentSpeed');
    }
  }

  void _stop() {
    setState(() {
      _counter = 0;
      currentSpeed = 0;
      isForward = false;
      isReversed = false;
      isLeft = false;
      isRight = false;
    });

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _initControlPanelStatus() {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControlPanelStatus();
    });
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            flex: 2,
            child: Container(
                child: ValueListenableBuilder<Bitmap>(
              valueListenable: SpbMqttClient.bmValueNotifier,
              builder: (BuildContext context, Bitmap bitmap, Widget child) {
                if (bitmap == null) {
                  return const CircularProgressIndicator();
                }
                return Center(
                  child: SafeArea(
                    top: true,
                    child: Image.memory(
                      bitmap.buildHeaded(),
                    ),
                  ),
                );
              },
            ))),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Try the',
                              style: TextStyle(color: textColor, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' race mode',
                                    style: TextStyle(color: HexColor("0c06c6")),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RaceMode()));
                                      })
                              ]),
                        ),
                      )))
            ],
          ),
        ),
        Spacer(),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
            ),
            //Spacer(),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 120,
                      child: Transform.rotate(
                        angle: 270 * pi / 180,
                        child: IconButton(
                          key: Key('forwards'),
                          onPressed: _forward,
                          splashRadius: 1.0,
                          iconSize: 90,
                          color: isForward ? strongShade : strongPrimary,
                          icon: Icon(
                            Icons.play_circle_fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Transform.rotate(
                      angle: 180 * pi / 180,
                      child: Container(
                        key: Key('left'),
                        margin: EdgeInsetsDirectional.only(start: 15),
                        child: Listener(
                          //Left and right button will be holded when turn, when they are released the smart car will keep on with it previse direction.
                          onPointerDown: (details) {
                            _left();
                          },
                          onPointerUp: (details) {
                            _cancelLeft();
                          },
                          child: Icon(
                            Icons.play_circle_fill,
                            color: isLeft ? midShade : strongPrimary,
                            size: 90,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextButton(
                      onPressed: _stop,
                      child: Text(
                        "S",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.shade700),
                        shape: MaterialStateProperty.all<CircleBorder>(
                          CircleBorder(
                              //borderRadius: BorderRadius.circular(18.0),
                              ),
                        ),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<CircleBorder>(
                      CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    child: Transform.rotate(
                      angle: 90 * pi / 180,
                      child: IconButton(
                        key: Key('backwards'),
                        onPressed: _backward,
                        splashRadius: 1.0,
                        iconSize: 90,
                        color: isReversed ? strongShade : strongPrimary,
                        icon: Icon(
                          Icons.play_circle_fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
              ]),
            ),
          //  Spacer(),
            Expanded(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                Flexible(
                    flex: 1,
                    child: Text("Current speed",
                        style: TextStyle(
                            color: strongPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Nexa Rust'))),
              ]),
            ),
            Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                  flex: 1,
                  child: TextButton(
                    child: Text("-"),
                    style: TextButton.styleFrom(
                      primary: textColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius. circular(15.0),
                            side: BorderSide(color: midPrimary)
                        ),
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nexa Rust')),
                    onPressed: _reduceSpeed,
                  )),
              Flexible(
                flex: 1,
                child: Text("   "+"$_counter"+"   ",
                    style: TextStyle(
                      letterSpacing: 4,
                        color: textColor,
                        //backgroundColor: lightShade,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nexa Rust')),
              ),
              Flexible(
                  flex: 1,
                  child: TextButton(
                    child: Text("+"),
                    style: TextButton.styleFrom(
                        primary: textColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius. circular(15.0),
                            side: BorderSide(color: midPrimary)
                        ),
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nexa Rust')),
                    onPressed: _addSpeed,
                  )),
            ])),
      )])
        );
  }
}
