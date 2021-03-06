import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SpbMqttClient {
  static MqttServerClient client;
  static bool isConnected = false;
  static ValueNotifier<Bitmap> bmValueNotifier =
      ValueNotifier(Bitmap.blank(320, 240));
  static var mqttError;
  static String address = '127.0.0.1';
}
