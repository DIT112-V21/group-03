import 'package:flutter/material.dart';
import 'flutter_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Controlpanel extends StatefulWidget {
  Controlpanel({Key key}) : super(key: key);
  static MqttServerClient client;
  @override
  ControlpanelState createState() => ControlpanelState();
}

class ControlpanelState extends State<Controlpanel> {
  // MqttClientConnection connection =
  //     MqttClientConnection("aerostun.dev", "group3App", 1883);
  MqttServerClient client = Controlpanel.client;
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
    _throttle('$currentSpeed');
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

  void _moreSpeed(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage('/smartcar/group3/control/moreSpeed',
        MqttQos.atLeastOnce, builder.payload);
  }

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

  void _beeDance() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: TextButton(
              child: Text('Connect'),
              onPressed: () => {
                connect().then((value) {
                  client = value;
                })
              },
            )),
            Flexible(
                child: TextButton(
              child: Text('BeeDance'),
              onPressed: _beeDance,
            )),
            Flexible(
                child: TextButton(
              child: Text('Circle'),
              onPressed: _circle,
            )),
            Flexible(
                child: TextButton(
              child: Text('Zigzag'),
              onPressed: _zigzag,
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: TextButton(
                  onPressed: _forward,
                  child: Text("forward"),
                  key: Key('forwards'),
                  style: ButtonStyle(
                      backgroundColor: isForward
                          ? MaterialStateProperty.all(Colors.red)
                          : MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                child: Listener(
                  //Left and right button will be holded when turn, when they are released the smart car will keep on with it previse direction.
                  onPointerDown: (details) {
                    _left();
                  },
                  onPointerUp: (details) {
                    _cancelLeft();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: isLeft ? Colors.orange : Colors.deepOrange,
                        border: Border.all()),
                    padding: EdgeInsets.all(16.0),
                    child: Text('left'),
                    key: Key('left'),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: TextButton(onPressed: _stop, child: Text("stop")),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                  child: Listener(
                    onPointerDown: (details) {
                      _right();
                    },
                    onPointerUp: (details) {
                      _cancelRight();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isRight ? Colors.pink : Colors.pinkAccent,
                          border: Border.all()),
                      padding: EdgeInsets.all(16.0),
                      child: Text('right'),
                      key: Key('right'),
                    ),
                  )),
            )
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: TextButton(
                onPressed: _backward,
                child: Text("backward"),
                key: Key('backwards'),
                style: ButtonStyle(
                    backgroundColor: isReversed
                        ? MaterialStateProperty.all(Colors.yellow[300])
                        : MaterialStateProperty.all(Colors.yellow[100]),
                    foregroundColor: MaterialStateProperty.all(Colors.black)),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(flex: 1, child: Text("Current speed")),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        ])
      ]),
    );
  }
}
