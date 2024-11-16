import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketModel with ChangeNotifier {
  late WebSocketChannel _channel;

  void connect(String wsUrl) {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  }

  Stream<dynamic> get messages => _channel.stream;

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void disconnect() {
    _channel.sink.close();
  }
}