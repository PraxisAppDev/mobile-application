import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketModel with ChangeNotifier {
  WebSocketChannel? _channel;
  late Stream<dynamic> _broadcastStream;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect(String wsUrl) {
    if (_isConnected) return;
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _broadcastStream = _channel!.stream.asBroadcastStream();
    _isConnected = true;
    notifyListeners();
  }

  Stream<dynamic> get messages => _broadcastStream;

  void sendMessage(String message) {
    if (_isConnected) {
      _channel!.sink.add(message);
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    notifyListeners();
  }
}