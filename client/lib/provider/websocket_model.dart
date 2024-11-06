import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final WebSocketChannel channel;
  final Function(Map<String, dynamic>) onMessageReceived;

  WebSocketService(String url, this.onMessageReceived)
      : channel = WebSocketChannel.connect(Uri.parse(url)) {
    _listenToMessages();
  }

  // Listen for incoming messages and pass them to the callback
  void _listenToMessages() {
    channel.stream.listen((message) {
      final Map<String, dynamic> data = json.decode(message);
      onMessageReceived(data);
    });
  }

  // Method to send messages
  void sendMessage(String message) {
    channel.sink.add(message);
  }

  // Close the WebSocket connection
  void close() {
    channel.sink.close(status.normalClosure);
  }
}

class WebSocketModel with ChangeNotifier {
  final Map<String, WebSocketService> _sockets = {};
  final Map<String, Map<String, dynamic>> _data = {}; // Store JSON data per connection

  // Connect to a WebSocket and set up data storage
  WebSocketService connect(String identifier, String url) {
    if (_sockets.containsKey(identifier)) {
      throw Exception("WebSocket with this identifier already exists.");
    }

    final service = WebSocketService(url, (data) {
      _data[identifier] = data;
      notifyListeners();
    });

    _sockets[identifier] = service;
    return service;
  }

  Map<String, dynamic>? getData(String identifier) => _data[identifier];

  WebSocketService? getSocket(String identifier) => _sockets[identifier];

  // Close a specific WebSocket connection and clear its data
  void closeSocket(String identifier) {
    _sockets[identifier]?.close();
    _sockets.remove(identifier);
    _data.remove(identifier);
    notifyListeners();
  }

  // Close all WebSocket connections and clear all data
  void closeAll() {
    _sockets.forEach((_, socket) => socket.close());
    _sockets.clear();
    _data.clear();
    notifyListeners();
  }
}