import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:praxis_afterhours/provider/game_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:praxis_afterhours/provider/websocket_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: Colors.grey[800],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void connectWebSocket(WebSocketModel webSocketModel, HuntProgressModel huntProgressModel) {
  webSocketModel.connect()
      'ws://afterhours.praxiseng.com/ws/hunt?huntId=$huntId&teamId=$teamId&playerName=$playerName&huntAlone=false');
  try {
    print('Connecting to WebSocket at: $wsUrl');
    var channel = WebSocketChannel.connect(wsUrl);

    channel.stream.listen(
      (message) {
        try {
          final data = json.decode(message) as Map<String, dynamic>;
          final eventType = data['eventType'];
          webSocketModel.updateEvent(eventType, data);
          print("Received message: $message");
        } catch (e) {
          print('Error parsing WebSocket message: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
    );
  } catch (e) {
    print('Failed to connect to WebSocket: $e');
  }
}
