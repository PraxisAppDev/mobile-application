import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(String url)
: channel = WebSocketChannel.connect(Uri.parse(url));

  Stream get stream => channel.stream;

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void close() {
    channel.sink.close(status.normalClosure);
  }
}

class WebSocketModel with ChangeNotifier {
  final Map<String, WebSocketService> _sockets = {};

  WebSocketService connect(String identifier, String url) {
    if (_sockets.containsKey(identifier)) {
      throw Exception("Websocket with this identifier already exists.");
    }
    final service = WebSocketService(url);
    _sockets[identifier] = service;
    return service;
  }

  // Retrieve an existing websocket connection
  WebSocketService? getSocket(String identifier) => _sockets[identifier];

  // Close a specific websocket connection
  void closeSocket(String identifier) {
    _sockets[identifier]?.close();
    _sockets.remove(identifier);
  }

  // Close all websocket connections
  void closeAll() {
    _sockets.forEach((_, socket) => socket.close());
    _sockets.clear();
  }
}