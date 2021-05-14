import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
//import 'flutter_mqtt_client.dart';
import 'package:smart_pet_buddy/racemode.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math';
import 'package:smart_pet_buddy/spbMqttClient.dart';

//ignore: must_be_immutable
class Controlpanel extends StatefulWidget {
  Controlpanel({
    Key key,
  }) : super(key: key);
  //MqttServerClient client;
  @override
  ControlpanelState createState() => ControlpanelState();
}

class ControlpanelState extends State<Controlpanel> {
  // MqttClientConnection connection =
  //     MqttClientConnection("aerostun.dev", "group3App", 1883);

  MqttServerClient client = SpbMqttClient.client;
  ValueNotifier<Image> imageValueNotifier;

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

  //ImageView mCameraView;

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

  // ignore: unused_element
  void _moreSpeed(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage('/smartcar/group3/control/moreSpeed',
        MqttQos.atLeastOnce, builder.payload);
  }

  // ignore: unused_element
  void _lessSpeed(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage('/smartcar/group3/control/lessSpeed',
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
    // TODO: implement initState
    super.initState();
    // imageValueNotifier.value = SpbMqttClient.image;
  }

  @override
  void dispose() {
    imageValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //alignment: Alignment.center,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        // Expanded(
        //   flex: 1,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Flexible(
        //           child: SpbMqttClient.isConnected
        //               ?
        //                TextButton(
        //                   child: Text('Disconnect',style: TextStyle(color: Colors.red)),
        //                   onPressed: () => {(){
        //                     client.disconnect();
        //                     setState(() {});
        //
        //                   }
        //
        //                   },
        //                 ):TextButton(
        //                     child: Text('Connect',style: TextStyle(color: Colors.green)),
        //                     onPressed: () => {
        //                         connect().then((value) {
        //                           client = value;
        //                           SpbMqttClient.client = client;
        //                           setState(() {});
        //                            })
        //                             },
        //                       )
        //       ),
        //     ],
        //   ),
        // ),
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
                child: TextButton(
                  child: Text('Try the race mode!'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RaceMode()
                        //       )
                        //       ),),
                        ),
                  ),
                ),
              )

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
                      color:
                          isForward ? HexColor("809ec2") : HexColor("aebccb"),
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
                        color: isLeft ? HexColor("809ec2") : HexColor("aebccb"),
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
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<CircleBorder>(
                      CircleBorder(
                          //borderRadius: BorderRadius.circular(18.0),
                          ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Transform.rotate(
                  angle: 0 * pi / 180,
                  child: Container(
                    key: Key('right'),
                    margin: EdgeInsetsDirectional.only(start: 15),
                    child: Listener(
                      //Left and right button will be holded when turn, when they are released the smart car will keep on with it previse direction.
                      onPointerDown: (details) {
                        _right();
                      },
                      onPointerUp: (details) {
                        _cancelRight();
                      },
                      child: Icon(
                        Icons.play_circle_fill,
                        color:
                            isRight ? HexColor("809ec2") : HexColor("aebccb"),
                        size: 90,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    color: isReversed ? HexColor("809ec2") : HexColor("aebccb"),
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
        Spacer(),
        Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(flex: 1, child: Text("Current speed")),
          ]),
        ),
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
              flex: 1,
              child: TextButton(
                child: Text("-"),
                onPressed: _reduceSpeed,
              )),
          Flexible(
            flex: 1,
            child: Text("$_counter"),
          ),
          Flexible(
              flex: 1,
              child: TextButton(
                child: Text("+"),
                onPressed: _addSpeed,
              )),
        ])),
      ]),
    );
  }
}
