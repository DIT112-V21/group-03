import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:smart_pet_buddy/spbMqttClient.dart';

Future<MqttClient> connect() async {
  MqttServerClient client = MqttServerClient(SpbMqttClient.address, 'group3');
  // MqttServerClient client = MqttServerClient('aerostun.dev', 'group3');

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
    SpbMqttClient.mqttError = e;
    client.disconnect();
  }

  if (client.connectionStatus.state == MqttConnectionState.connected) {
    SpbMqttClient.isConnected = true;
    print('EMQX client connected');
    client.subscribe("/smartcar/group3/camera", MqttQos.atMostOnce);
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (c[0].topic == '/smartcar/group3/camera') {
        Uint8List incomingData = Uint8List.view(message.payload.message.buffer);
        // List<int> picData = [];

        // for (var i = 0; i < incomingData.length; i++) {
        //   picData.add(incomingData[i]);
        //   if (i % 3 == 2) {
        //     picData.add(255);
        //   }
        // }

        // Uint8List picBm = Uint8List.fromList(picData);
        Uint8List picBM = new Uint8List(307200);
        int helper = 0;
        for (var i = 0; i < 230400; i++) {
          picBM[i + helper] = incomingData[i];
          if (i % 3 == 2) {
            helper++;
            picBM[i + helper] = 255;
          }
        }
        Bitmap bm = Bitmap.fromHeadless(320, 240, picBM);
        SpbMqttClient.bmValueNotifier.value = bm;
      } else {
        print('Received message:$payload from topic: ${c[0].topic}>');
      }
    });
  } else {
    SpbMqttClient.isConnected = false;
    client.disconnect();
    // exit(-1);
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
