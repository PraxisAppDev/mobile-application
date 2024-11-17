import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketModel with ChangeNotifier {
  late WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;

  void connect(String wsUrl) {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _broadcastStream = _channel.stream.asBroadcastStream();
  }

  Stream<dynamic> get messages => _broadcastStream;

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void disconnect() {
    _channel.sink.close();
  }
}