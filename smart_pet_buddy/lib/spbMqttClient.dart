import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SpbMqttClient {
  static MqttServerClient client;
  static bool isConnected = false;
  Bitmap initPic =
      await Bitmap.fromProvider(AssetImage("assets/images/cat.jpeg"));
  static ValueNotifier<Bitmap> bmValueNotifier = ValueNotifier(initPic);
  // static Image image = Image.asset('homepage.jpg');
}
