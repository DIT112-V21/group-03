import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';

import 'package:smart_pet_buddy/spbMqttClient.dart';

Future<MqttClient> connect() async {
  // MqttServerClient client = MqttServerClient('127.0.0.1', 'group3');
  MqttServerClient client = MqttServerClient('aerostun.dev', 'group3');

  client.setProtocolV311();
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMess = MqttConnectMessage()
      .withClientIdentifier('group3')
      .keepAliveFor(60)
      .withWillTopic('willtopic')
      .withWillMessage('My Will message')
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMess;
  try {
    print('Connecting');
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  if (client.connectionStatus.state == MqttConnectionState.connected) {
    print('EMQX client connected');
    client.subscribe("/smartcar/group3/camera", MqttQos.atMostOnce);
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (c[0].topic == '/smartcar/group3/camera') {
        Uint8List incomingData = Uint8List.view(message.payload.message.buffer);
        List<int> picData = [];
        for (var i = 0; i < incomingData.length; i++) {
          picData.add(incomingData[i]);
          if (i % 3 == 2) {
            picData.add(255);
          }
        }
        Uint8List picBm = Uint8List.fromList(picData);
        Bitmap bm = Bitmap.fromHeadless(320, 240, picBm);
        SpbMqttClient.bmValueNotifier.value = bm;
        // Image image = Image.memory(bm.buildHeaded());
        // SpbMqttClient.image = image;
      } else {
        print('Received message:$payload from topic: ${c[0].topic}>');
      }
    });
  } else {
    client.disconnect();
    exit(-1);
  }

  return client;
}



void onConnected() {
  SpbMqttClient.isConnected = true;

  print('Connected');
}

void onDisconnected() {
  SpbMqttClient.isConnected = false;

  print('Disconnected');
}

void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

void onSubscribeFail(String topic) {
  print('Failed to subscribe topic: $topic');
}

void onUnsubscribed(String topic) {
  print('Unsubscribed topic: $topic');
}

void pong() {
  print('Ping response client callback invoked');
}
