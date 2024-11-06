import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

class PlayerJoinedTeam {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final String teamId;
  final String playerId;
  final String huntId;
  final bool isHuntingAlone;
  bool _isConnected = false;
  PlayerJoinedTeam({
    required this.teamId,
    required this.playerId,
    required this.huntId,
    this.isHuntingAlone = false,
  });
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _isConnected;
  Future<void> connect() async {
    if (_channel != null) return;
    try {
      final wsUrl = Uri.parse(
          'ws://afterhours.praxiseng.com/ws/hunt/$huntId?teamId=$teamId&playerId=$playerId&huntAlone=$isHuntingAlone');
      _channel = WebSocketChannel.connect(wsUrl);
      _isConnected = true;
      // Listen for incoming messages
      _channel?.stream.listen(
        (dynamic message) {
          try {
            final Map<String, dynamic> decodedMessage =
                json.decode(message as String) as Map<String, dynamic>;
            if (decodedMessage['api_version'] == '1' &&
                decodedMessage['message_type'] == 'PLAYER_JOINED_TEAM') {
              _handleMessage(decodedMessage);
            }
          } catch (e) {
            debugPrint('Error parsing message: $e');
          }
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _handleDisconnect();
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
          _handleDisconnect();
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      _handleDisconnect();
    }
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (message['message_type'] == 'PLAYER_JOINED_TEAM') {
      final playerJoinedEvent = {
        'api_version': message['api_version'],
        'message_type': 'PLAYER_JOINED_TEAM',
        'huntId': message['huntId'],
        'huntName': message['huntName'],
        'teamId': message['teamId'],
        'teamName': message['teamName'],
        'playerId': message['playerId'],
        'playerName': message['playerName'],
      };
      _messageController.add(playerJoinedEvent);
    }
  }

  void _handleDisconnect() {
    _isConnected = false;
    _channel = null;
  }

  void disconnect() {
    _channel?.sink.close();
    _handleDisconnect();
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
