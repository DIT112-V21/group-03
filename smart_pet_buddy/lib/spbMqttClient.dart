import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SpbMqttClient {
  static MqttServerClient client;
  static bool isConnected = false;
  static ValueNotifier<Bitmap> imageValueNotifier;
}
