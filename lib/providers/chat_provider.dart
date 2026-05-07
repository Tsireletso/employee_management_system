import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void sendMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  List<ChatMessage> getConversation(String user1, String user2) {
    return _messages.where((msg) {
      return (msg.sender == user1 && msg.receiver == user2) ||
             (msg.sender == user2 && msg.receiver == user1);
    }).toList();
  }
}