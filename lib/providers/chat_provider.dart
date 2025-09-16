import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final List<Map<String, String>> _chatHistory = [];

  List<Map<String, String>> get messages => _messages;
  List<Map<String, String>> get chatHistory => _chatHistory;

  void addUserMessage(String text) {
    _messages.add({'sender': 'user', 'text': text});
    _chatHistory.add({'role': 'user', 'content': text});
    notifyListeners();
  }

  void addBotMessage(String text) {
    _messages.add({'sender': 'ai', 'text': text});
    _chatHistory.add({'role': 'assistant', 'content': text});
    notifyListeners();
  }

  void addSystemMessage(String text) {
    _chatHistory.add({'role': 'system', 'content': text});
  }

  void reset() {
    _messages.clear();
    _chatHistory.clear();
    notifyListeners();
  }
}
